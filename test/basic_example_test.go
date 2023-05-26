package test

import (
	"os"
	"testing"

	TTAWS "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"

	"github.com/stretchr/testify/assert"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
)

func TestTerraformBasicExample(t *testing.T) {
	sgName := "terraform-test-security-group-" + GetShortId()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic-example",
		Vars: map[string]interface{}{
			"name": sgName,
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	security_group_id := terraform.Output(t, terraformOptions, "security_group_id")
	assert.NotEmpty(t, security_group_id)

	sess, err := NewSession(os.Getenv("AWS_REGION"))
	assert.NoError(t, err)

	client := ec2.New(sess)

	sgInput := ec2.DescribeSecurityGroupsInput{GroupIds: []*string{&security_group_id}}
	sgOutput, err := client.DescribeSecurityGroups(&sgInput)
	assert.NoError(t, err)

	assert.Equal(t, 1, len(sgOutput.SecurityGroups))
	assert.Equal(t, 1, len(sgOutput.SecurityGroups[0].IpPermissions))
	assert.Equal(t, 1, len(sgOutput.SecurityGroups[0].IpPermissionsEgress))

	assert.Equal(t, int64(80), aws.Int64Value(sgOutput.SecurityGroups[0].IpPermissions[0].FromPort))
	assert.Equal(t, "0.0.0.0/0", aws.StringValue(sgOutput.SecurityGroups[0].IpPermissions[0].IpRanges[0].CidrIp))

	assert.Equal(t, int64(80), aws.Int64Value(sgOutput.SecurityGroups[0].IpPermissionsEgress[0].FromPort))
	assert.Equal(t, "0.0.0.0/0", aws.StringValue(sgOutput.SecurityGroups[0].IpPermissionsEgress[0].IpRanges[0].CidrIp))
}

func NewSession(region string) (*session.Session, error) {
	sess, err := TTAWS.NewAuthenticatedSession(region)
	if err != nil {
		return nil, err
	}

	return sess, nil
}

func GetShortId() string {
	githubSha := os.Getenv("GITHUB_SHA")
	if len(githubSha) >= 7 {
		return githubSha[0:6]
	}

	return "local"
}
