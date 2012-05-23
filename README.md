## Grittle - Git Visualisations for OmniGraffle

### Your OmniGraffle needs to be configured to open a default window with a blank template - else the script will fail.

* Everything is pre-alpha
* Performance patches _very_ welcome.

Performance is so agonising right now because we shell out to `osascript(1)` once for every graphic (and three times for every line).

If this script simply generated a huge Applescript, I'm sure things would go ten times faster. It's a bit tricky, though.
Preliminary abstraction has been performed to caputre the generated applescript for use in building one large file.


## Test

```ruby grittle.rb .```
