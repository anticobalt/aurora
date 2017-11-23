# Aurora

A tag-centric file browser with a web-browser front. Written in Ruby 2.3.3 and Rails 5.0.2, for Windows 7.

<img src="https://vgy.me/RsWRPw.png" alt="Screenshot">

## Features
- Read, edit, move, rename, delete local .txt files
- Tag files, and organize tags in categories
- Quickly tag/untag many files at once
- BBCode support
- Recover from file renames/moves that are done outside of app
- Import and export app state (e.g. tags, categories, preferences)

## How to Use
0. Install Rails and Ruby. I haven't tested any versions other than the ones I used.
1. Download repository or `git clone` in terminal
2. In terminal/CMD, `cd` to program root
3. `bundle install`
4. `rake db:create` and `rake db:migrate`
5. `rails s` and go to localhost:3000 in Chrome or Firefox

## To-Do
- **Improve category management**
- **Warn about file extension changes**
- **Auto-tag files based on criteria (e.g. file name includes x)**
- **Linux support**
- Remove dependency on internet for fonts
- Support for other browsers (Opera, Edge, etc)
- Change font and colors in preferences
- Support other file types (.docx, etc)
- Set a favicon and custom error pages

## Known Bugs
- Slow, particularily on initial server load
- Warnings persist if you hit the browser back/forward button
- Checkboxes styled incorrectly in Firefox
- If you enter an invalid filename/directory when creating txt file, and submit, everything related to that file will be lost. Problem doesn't exist when updating an already existing txt file.
- If a category is empty due to all tags being deleted, it won't be removed.
- Occasionally freezes while loading until you press a key in the terminal

## (Hypothetical) FAQs
#### Why aren't Tags/Textfiles nested under Users?
The gem Acts-As-Taggable-On, which is used to allow for tagging, prevents modification to the Tag model. Therefore, I can't set Tags as a nested resource or put it in a :belongs_to relationship with Users. Since I can't nest Tags, I left Textfiles unnested as well, to keep everything consistent and on the same hierarchical level.
#### Why are you consistently accessing model attributes from outside of their controllers?
This is a consequence of the above problem.
#### Why do(es) the colours/fonts/layout look terrible?
I don't really have a keen eye for this kind of thing, unfortunately. They look pretty good to me.
#### Why did you remove Coffeescript?
Incompatible with 64-bit Windows, which I'm using.
#### Why are you using Windows with Ruby?
Admittedly, I thought I could get it to work, but now I'm pretty sure it's the root of most problems in this program.

## License
[MIT](LICENSE).
