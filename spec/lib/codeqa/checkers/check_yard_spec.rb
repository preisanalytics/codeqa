require 'spec_helper'

describe Codeqa::Checkers::CheckYard do
  it "should check rb files" do
    source = source_with("", "file.rb")
    described_class.check?(source).should be == true
    source = source_with("", "test.rhtml")
    described_class.check?(source).should be == false
  end

  it "should detect yard errors" do
    source = source_with("# @paramsssss\nclass MyClass\nend")
    checker = check_with(described_class, source)
    checker.should be_error
    detail = checker.errors.details[0][1]
    detail.should match(/Unknown tag @paramsssss in file/)
  end

end
