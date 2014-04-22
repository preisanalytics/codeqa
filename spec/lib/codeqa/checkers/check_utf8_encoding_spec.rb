require 'spec_helper'

describe Codeqa::Checkers::CheckUtf8Encoding do

  let (:checker_class) do
     Codeqa::Checkers::CheckUtf8Encoding
   end

  it "should check text files" do
    source = source_with
    checker_class.check?(source).should be == true
    source = source_with('', 'zipped.zip')
    checker_class.check?(source).should be == false
  end

  it "should detect non utf8 chars " do
    source = source_with("\xE4\xF6\xFC")
    checker = check_with(checker_class, source)
    checker.should be_error
    checker.errors.details.should be == [[nil, "encoding error, not utf8"]]
  end

  it "should find not find if not there " do
    source = source_with("first line")
    checker = check_with(checker_class, source)
    checker.should be_success
  end

end
