# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'filesystem_cleaner/version'

Gem::Specification.new do |spec|
  spec.name          = "filesystem_cleaner"
  spec.version       = FilesystemCleaner::VERSION
  spec.authors       = ["Mark Lorenz"]
  spec.email         = ["markjlorenz@dapplebeforedawn.com"]
  spec.description   = %q{For tests that need to modify files}
  spec.summary       = <<-SUMMARY
```ruby
# spec/spec_helper.rb

RSpec.configure do |config|
 fs_cleaner = FileSystemCleaner.new(
   Rails.root.join("public", "system", "test", "files"),
   Rails.root.join("tmp, "files.bak")
 )

 config.before(:each) { fs_cleaner.save_files!(example) }
 config.after(:each)  { fs_cleaner.restore_files!(example) }
end
```

```ruby
# spec/some_spec.rb

describe "a filesystem modification", file: true do  # `file: true` activates the cleaner
  before do
    test_file    = Rails.root.join("public", "system", "test", "files", "\#{filename}.txt")
    `cp \#{fixture_file} \#{test_file}`
  end

  it "reads the file" do
    expect(MyFileReader.new(filename).to_s).to eq(File.read(fixture_file))
  end

  let(:filename)     { SecureRandom.uuid }
  let(:fixture_file) { Rails.root.join("spec", "fixtures", "some_data.txt") }
end
```

After the test runs, `public/system/test/files` is restored to it's pre-test state.
  SUMMARY
  spec.homepage      = "https://github.com/dapplebeforedawn/filesystem-cleaner-gem"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "rspec", "~>2.0"
end
