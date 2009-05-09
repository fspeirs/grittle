#
# Script to generate a branch diagram in OmniGraffle
#
require 'rubygems'
require 'grit'
include Grit


def make_graphic_for_commit(c)
  shape = 'make new shape at end of graphics with properties {name:\"RoundRect\", textSize:{0.8, 1.0}, fill color:{0.718475, 1.0, 0.755425}, textPosition:{0.1, 0.0}, origin:{206.0, 270.0}, size:{121.0, 79.0}, draws shadow:false, text: {text: \"' + c.id[0,8] + '\", text: \"' + c.id[0,8] + '\", alignment: center}}'
  `osascript -e "tell application \\"Omnigraffle Professional 5\\"" -e "tell canvas of front window" -e "#{shape}" -e "end tell" -e "end tell"`
end

def make_graphic_for_tag(tag)
  shape = 'make new shape at end of graphics with properties {fill color: {0.760290, 0.952503, 1.000000}, origin: {60.000000, 84.000000}, size: {140.000000, 66.000000}, text: {text: \"' + tag.name + '\", text: \"' + tag.name + '\", alignment: center}, draws shadow: false}'
  `osascript -e "tell application \\"Omnigraffle Professional 5\\"" -e "tell canvas of front window" -e "#{shape}" -e "end tell" -e "end tell"`
end

def make_graphic_for_head(head)
  shape = 'make new shape at end of graphics with properties {name: \"Circle\", textSize: {0.800000, 0.700000}, fill color: {0.960518, 0.679012, 1.000000}, textPosition: {0.100000, 0.150000}, origin: {160.000000, 120.112358}, size: {118.000000, 39.775280}, text: {text: \"' + head.name + '\", text: \"' + head.name + '\", alignment: center}, draws shadow: false}'
  `osascript -e "tell application \\"Omnigraffle Professional 5\\"" -e "tell canvas of front window" -e "#{shape}" -e "end tell" -e "end tell"`
end

def make_line_between_graphics(commit, parent)
  linescript = 'make new line at end of graphics with properties {point list:{{255.7701, 269.5171}, {229.7299, 172.4829}}, head type:\"FilledArrow\", line type:curved}'
  `osascript -e "tell application \\"Omnigraffle Professional 5\\"" -e "tell canvas of front window" -e "#{linescript}" -e "set source of graphic -1 to #{commit}" -e "set destination of graphic -1 to #{parent}" -e "end tell" -e "end tell"`
end

def layout()
  `osascript -e "tell application \\"Omnigraffle Professional 5\\"" -e "tell canvas of front window" -e "layout" -e "end tell" -e "end tell"` 
end

def draw(head)
  
end

# Substitute the path to your repo (or send me a patch to make this accept args)
repo = Repo.new('/Users/fspeirs/Code/Flickr/Kit')
commits = repo.commits('master', 20) # second parameter is number of commits to use
shapes = {} # Shapes holds a hash of the commit id against the applescript reference to its graphic

# Create graphics for each commit object
commits.each { |c|
 shapes[c.id] = make_graphic_for_commit(c)
 puts shapes[c.id]
}

# For each commit, iterate its parents then draw lines
commits.each { |c|
  c.parents.each { |p|
    if shapes.has_key? p.id then
      make_line_between_graphics(shapes[c.id], shapes[p.id])
    end
    }
  }

# Create graphics for all the tags  
repo.tags.each { |t|
    if shapes.has_key? t.commit.id then #if we didn't draw the commit, don't draw the tag that refs it.
      tagGraphic = make_graphic_for_tag(t)
      make_line_between_graphics(tagGraphic, shapes[t.commit.id])
    end
  }
  
# Create graphics for the heads
  repo.heads.each { |h|
    if shapes.has_key? h.commit.id then
      headGraphic = make_graphic_for_head(h)
      make_line_between_graphics(headGraphic, shapes[h.commit.id])
    end
    }
  
# Tidy up
  layout()