#
# Script to generate a branch diagram in OmniGraffle
#
require 'rubygems'
require 'grit'
include Grit
require 'graphviz'

def print_commit_node(commit)
  puts "\"#{commit.id[0,8]}\" [shape=box     , regular=1,style=filled,fillcolor=white   ] ;"
end

# Substitute the path to your repo (or send me a patch to make this accept args)
repo = Repo.new('/Users/fspeirs/Code/Git')
commits = repo.commits('master', 250) # second parameter is number of commits to use
shapes = {} # Shapes holds a hash of the commit id against the applescript reference to its graphic

puts "digraph Git {"
# Create graphics for each commit object
commits.each { |c|
 c.parents.each { |p|
   puts "\"#{c.id[0,8]}\" -> \"#{p.id[0,8]}\" ;"

 }
}

# Create heads
repo.heads.each { |h|
  puts "\"#{h.name}\" -> \"#{h.commit.id[0,8]}\" ;"
  }
puts "}"