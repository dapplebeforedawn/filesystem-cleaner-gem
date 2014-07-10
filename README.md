# FilesystemCleaner

Like [database_cleaner](https://github.com/DatabaseCleaner/database_cleaner), but for tests that do file manipulation.

## Installation

Add this line to your application's Gemfile and bundle:

```ruby
group :test do
  gem 'filesystem_cleaner'
end
```

## Usage
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
    test_file    = Rails.root.join("public", "system", "test", "files", "#{filename}.txt")
    `cp #{fixture_file} #{test_file}`
  end

  it "reads the file" do
    expect(MyFileReader.new(filename).to_s).to eq(File.read(fixture_file))
  end

  let(:filename)     { SecureRandom.uuid }
  let(:fixture_file) { Rails.root.join("spec", "fixtures", "some_data.txt") }
end
```

After the test runs, `public/system/test/files` is restored to it's pre-test state.

## Bonus

This has nothing to do with filesystem cleaner, but is a neat trick if you have to look at the files after the test to know if they were modified correctly (e.g. pdfs)

```ruby
describe "applying a signature", file: true do

  before do
    `cp #{Settings.fixture_drawing} #{working_file}`
    post "/documents/#{document.id}/sign"
  end

  it "applies the engineer's signature" do
     # `quality_assurance_dir` is _not_ cleaned by filesystem_cleaner
    `cp #{working_file} #{Settings.quality_assurance_dir}`

    fname = filename
    RSpec.configure do |config|
      config.after(:suite) do
        qa_file_path = "#{Settings.quality_assurance_dir}/#{fname}"
        message      = "ssh me@my-host cat #{qa_file_path} | display - "
        puts
        puts
        print message
      end
    end
  end

end
```

Produces a nice output:
```
$ bundle exec rspec
............*.......

ssh me@my-host cat /home/me/app/spec/support/qa/b5f69a0-aa53-c39e0c27e2 | display -

Pending:
  Some spec is pending for some reason or other
    # No reason given
    # ./spec/mailers/mailer_spec.rb:8
```

Now you can just copy and paste that ssh command to view the file locally.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
