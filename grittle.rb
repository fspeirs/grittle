#
# Script to generate a branch diagram in OmniGraffle

# Gems
require 'rubygems'
require 'grit'
include Grit

# Helpers
require 'osas_draws'

if ARGV.empty?
  puts "usage: $0 path/to/repo"
  puts " "
  puts "    --commits=20  : number of commits to draw"
  puts "    --base=master : beginning node"
else 
  commits   = ARGV.join(',').scan(/--commits=[0-9]*/).first.split('=')[1] rescue 20
  base_node = ARGV.join(',').scan(/--base=[a-zA-Z0-9_.-]*/).first.split('=')[1] rescue 'master'

  # Substitute the path to your repo (or send me a patch to make this accept args)
  repo = Repo.new(ARGV[0])
  commits = repo.commits( base_node, commits ) # second parameter is number of commits to use
  shapes = {} # Shapes holds a hash of the commit id against the applescript reference to its graphic

  puts "\n# Create graphics for each commit object "
  commits.each do |c|
   shapes[c.id] = make_graphic_for_commit(c)
   puts "- " + shapes[c.id]
  end

  "# For each commit, iterate its parents then draw lines "
  commits.each do |c|
    c.parents.each do |p|
      if shapes.has_key? p.id then
        make_line_between_graphics(shapes[c.id], shapes[p.id])
      end
    end
  end

  puts "# Create graphics for all the tags   "
  repo.tags.each do |t|
      if shapes.has_key? t.commit.id then #if we didn't draw the commit, don't draw the tag that refs it.
        tagGraphic = make_graphic_for_tag(t)
        make_line_between_graphics(tagGraphic, shapes[t.commit.id])
      end
  end
    
  puts "# Create graphics for the heads "
  repo.heads.each do |h|
    if shapes.has_key? h.commit.id then
      headGraphic = make_graphic_for_head(h)
      make_line_between_graphics(headGraphic, shapes[h.commit.id])
    end
  end
    
  puts "# Tidy up "
    layout()

  puts "Done!"
end
