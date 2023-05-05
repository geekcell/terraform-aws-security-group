package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"

	"github.com/stretchr/testify/assert"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
)

func TestTerraformFull(t *testing.T) {
	sgName := "terraform-test-security-group-" + GetShortId()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/full",
		Vars: map[string]interface{}{
			"name": sgName,
		},
	})

	// defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	security_group_id := terraform.Output(t, terraformOptions, "security_group_id")
	assert.NotEmpty(t, security_group_id)

	source_security_group := terraform.Output(t, terraformOptions, "source_security_group")
	assert.NotEmpty(t, source_security_group)

	sess, err := NewSession(os.Getenv("AWS_REGION"))
	assert.NoError(t, err)

	client := ec2.New(sess)

	sgInput := ec2.DescribeSecurityGroupsInput{GroupIds: []*string{&security_group_id}}
	sgOutput, err := client.DescribeSecurityGroups(&sgInput)
	assert.NoError(t, err)

	assert.Equal(t, 1, len(sgOutput.SecurityGroups))
	// only 3 groups, because port 3306 rules get grouped
	assert.Equal(t, 3, len(sgOutput.SecurityGroups[0].IpPermissions))
	assert.Equal(t, 3, len(sgOutput.SecurityGroups[0].IpPermissionsEgress))

	EnsureIpPermission(t, sgOutput.SecurityGroups[0].IpPermissions, 3306, 3306, "tcp", []string{"0.0.0.0/0"}, "")
	EnsureIpPermission(t, sgOutput.SecurityGroups[0].IpPermissions, 3306, 54321, "tcp", []string{"127.0.0.0/8", "10.0.0.0/8"}, "")
	EnsureIpPermission(t, sgOutput.SecurityGroups[0].IpPermissions, 3306, 3306, "udp", []string{}, source_security_group)
	EnsureIpPermission(t, sgOutput.SecurityGroups[0].IpPermissions, 3306, 3306, "udp", []string{}, security_group_id)

	EnsureIpPermission(t, sgOutput.SecurityGroups[0].IpPermissionsEgress, 3306, 3306, "tcp", []string{"0.0.0.0/0"}, "")
	EnsureIpPermission(t, sgOutput.SecurityGroups[0].IpPermissionsEgress, 3306, 54321, "tcp", []string{"127.0.0.0/8", "10.0.0.0/8"}, "")
	EnsureIpPermission(t, sgOutput.SecurityGroups[0].IpPermissionsEgress, 3306, 3306, "udp", []string{}, source_security_group)
	EnsureIpPermission(t, sgOutput.SecurityGroups[0].IpPermissionsEgress, 3306, 3306, "udp", []string{}, security_group_id)
}

func EnsureIpPermission(
	t *testing.T,
	ipPermissions []*ec2.IpPermission,
	fromPort int,
	toPort int,
	protocol string,
	cidrBlocks []string,
	securityGroup string,
) {
	for _, ipPermission := range ipPermissions {
		fromPortMatch := int64(fromPort) == aws.Int64Value(ipPermission.FromPort)
		toPortMatch := int64(toPort) == aws.Int64Value(ipPermission.ToPort)
		protocolMatch := protocol == aws.StringValue(ipPermission.IpProtocol)

		cidrBlocksMatch := false
		if len(cidrBlocks) == 0 {
			cidrBlocksMatch = true
		} else {
			configuredCidrBlocks := []string{}
			for _, ipRange := range ipPermission.IpRanges {
				configuredCidrBlocks = append(configuredCidrBlocks, *ipRange.CidrIp)
			}

			diff := difference(cidrBlocks, configuredCidrBlocks)
			cidrBlocksMatch = len(diff) == 0
		}

		securityGroupMatches := false
		if securityGroup == "" {
			securityGroupMatches = true
		} else {
			for _, userIdGroupPair := range ipPermission.UserIdGroupPairs {
				if securityGroup == aws.StringValue(userIdGroupPair.GroupId) {
					securityGroupMatches = true
					break
				}
			}
		}

		if fromPortMatch && toPortMatch && protocolMatch && cidrBlocksMatch && securityGroupMatches {
			return
		}
	}

	t.Errorf("Could not find matching rule! from: %d, to: %d protocol: %s, cidr: %v, security group: %s", fromPort, toPort, protocol, cidrBlocks, securityGroup)
}

func difference(a, b []string) []string {
	mb := make(map[string]struct{}, len(b))
	for _, x := range b {
		mb[x] = struct{}{}
	}
	var diff []string
	for _, x := range a {
		if _, found := mb[x]; !found {
			diff = append(diff, x)
		}
	}
	return diff
}
