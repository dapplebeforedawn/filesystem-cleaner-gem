require "filesystem_cleaner/version"

# Usage:
#
# RSpec.configure do |config|
#   fs_cleaner = FileSystemCleaner.new(
#     Rails.root.join("public", "system", "test", "files"),
#     Rails.root.join("tmp", "files.bak")
#   )
#
#   config.before(:each) { fs_cleaner.save_files!(example) }
#   config.after(:each)  { fs_cleaner.restore_files!(example) }
# end
#
class FileSystemCleaner

  attr_reader :filesystem_under_test, :backup_location

  def initialize filesystem_under_test, backup_location
    @filesystem_under_test = filesystem_under_test
    @backup_location       = backup_location
  end

  def save_files!(example)
    return unless should_perform?(example)
    `rsync -a #{filesystem_under_test}/ #{backup_location}`
  end

  def restore_files!(example)
    return unless should_perform?(example)
    `rsync -a --delete #{backup_location}/ #{filesystem_under_test}/`
  end

  private

  def should_perform?(example)
    example.metadata[:file]
  end

end
