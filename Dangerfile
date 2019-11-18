# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = github.pr_title.include? "#trivial"

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Warn when there is a big PR
warn "Big PR, consider splitting into smaller" if git.lines_of_code > 500

# Ensure a clean commits history
if git.commits.any? { |c| c.message =~ /^Merge branch '#{github.branch_for_base}'/ }
  fail "Please rebase to get rid of the merge commits in this PR"
end

# Mainly to encourage writing up some reasoning about the PR, rather than
# just leaving a title
#if github.pr_body.length < 5
#  fail "Please provide a summary in the Pull Request description"
#end

# If these are all empty something has gone wrong, better to raise it in a comment
if git.modified_files.empty? && git.added_files.empty? && git.deleted_files.empty?
  fail "This PR has no changes at all, this is likely an issue during development."
end

has_app_changes = !git.modified_files.grep(/Classes/).empty? && !git.added_files.grep(/Sources/).empty?
has_test_changes = !git.modified_files.grep(/Tests/).empty? && !git.added_files.grep(/Tests/).empty?

if has_app_changes
  warn "has_app_changes = true"
else
  warn "has_app_changes = false"
end
if has_test_changes
  warn "has_test_changes = true"
else
  warn "has_test_changes = false"
end

warn "git.modified_files = #{git.modified_files}"
warn "git.modified_files.grep = #{git.modified_files.grep(/Tests/)}"
warn "git.added_files = #{git.added_files}"
warn "git.added_files.grep = #{git.added_files.grep(/Tests/)}"

# If changes are more than 10 lines of code, tests need to be updated too
if has_app_changes && !has_test_changes && git.lines_of_code > 10
  warn("Tests were not updated", sticky: false)
end

# Info.plist file shouldn't change often. Leave warning if it changes.
#is_plist_change = git.modified_files.sort == ["DNSCore/Info.plist"].sort
#if !is_plist_change
#  warn "Info.plist changed, don't forget to localize your plist values"
#end

# Leave warning, if Podfile changes
#podfile_updated = !git.modified_files.grep(/Podfile/).empty?
#if podfile_updated
#  warn "The `Podfile` was updated"
#end
