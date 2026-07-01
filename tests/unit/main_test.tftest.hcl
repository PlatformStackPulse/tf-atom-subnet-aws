# Unit Tests for tf-atom-subnet-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:        terraform test -test-directory=tests/unit
# Run verbose:     terraform test -test-directory=tests/unit -verbose
# Run specific:    terraform test -test-directory=tests/unit -run "creates_when_enabled"
#
# IMPORTANT: assertions are on plan-KNOWN values only (tf-label id string,
# resource count, input pass-throughs, the enabled flag). Computed attributes
# such as the subnet arn/id are unknown under a mock provider and are NOT asserted.

mock_provider "aws" {}

variables {
  # tf-label context inputs
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # module's own required inputs (valid sample values)
  vpc_id            = "vpc-0123456789abcdef0"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

# ---------------------------------------------------------------------------
# Test: Module creates the subnet when enabled (the default)
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "enabled output should be true when the module is enabled"
  }

  assert {
    condition     = length(aws_subnet.this) == 1
    error_message = "exactly one aws_subnet should be planned when enabled"
  }

  assert {
    condition     = aws_subnet.this[0].tags["Name"] == "eg-test-thing"
    error_message = "subnet Name tag should equal the tf-label id 'eg-test-thing'"
  }
}

# ---------------------------------------------------------------------------
# Test: Required inputs are passed through to the subnet resource
# ---------------------------------------------------------------------------
run "passes_through_inputs" {
  command = plan

  assert {
    condition     = aws_subnet.this[0].vpc_id == "vpc-0123456789abcdef0"
    error_message = "vpc_id should be passed through to the subnet"
  }

  assert {
    condition     = aws_subnet.this[0].cidr_block == "10.0.1.0/24"
    error_message = "cidr_block should be passed through to the subnet"
  }

  assert {
    condition     = aws_subnet.this[0].availability_zone == "us-east-1a"
    error_message = "availability_zone should be passed through to the subnet"
  }
}

# ---------------------------------------------------------------------------
# Test: Module creates nothing when disabled
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.enabled == false
    error_message = "enabled output should be false when disabled"
  }

  assert {
    condition     = length(aws_subnet.this) == 0
    error_message = "no aws_subnet should be planned when disabled"
  }

  assert {
    condition     = output.id == null
    error_message = "id output should be null when disabled"
  }

  assert {
    condition     = output.arn == null
    error_message = "arn output should be null when disabled"
  }
}
