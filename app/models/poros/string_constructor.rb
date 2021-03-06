require 'pathname'

class StringConstructor
  def self.parent_directory(abs_path)
    File.dirname(abs_path)
  end

  # E.g. an abs_path of "C:\\Documents\\foo\\bar.png" and root of "C:\\"
  # => yields "Documents\\foo"; used by Textfile form
  def self.relative_directory(abs_path, root)
    # File path in style foo/bar, while everywhere else it's foo\bar
    relative_path = Pathname.new(abs_path).relative_path_from Pathname.new(root)
    relative_path_str = relative_path.to_s
    relative_path_str.gsub!("/", "\\")
    dir = self.parent_directory relative_path_str
    # Handle file being in root level
    unless dir == "."
      return dir
    else
      return ""
    end
  end

  # Gets rid of extra or incorrect slashes created by concatenation of path partials or user error
  def self.sanitized_filepath(path)
    arr = path.split("\\")
    arr2 = []
    arr.each {|obj| arr2 += obj.split("/") }
    sanitized_arr = []
    arr2.each {|obj| sanitized_arr << obj unless obj == ""}
    return sanitized_arr.join("\\")
  end

  def self.snippet(text)
    begin
      lines = text.split("\n")
    rescue ArgumentError
      return "ERROR: invalid characters found in file. Ensure that the file is encoded in UTF-8."
    end

    if text.length < 1000 and lines.length < 20
      snip = text
    else
      # If text is long despite not having a lot of lines
      if text.scan(/.{1,70}/).length > lines.length
        snip = text[0...20*70] + (text[20*70..-1].split("\n")[0]).to_s

      # If text is short character-wise but has a lot of lines
      elsif lines.length >= 20
        snip = lines[0..20].join("\n")
      end
    end
    return self.bbcode_to_html(snip)
  end

  # Supports bold, italics, underline, strikethrough
  def self.bbcode_to_html(text)
    converted_text = text.dup
    bb_html_pairs = {"[b]": "<strong>",
                      "[/b]": "</strong>",
                      "[i]": "<em>",
                      "[/i]": "</em>",
                      "[u]": "<u>",
                      "[/u]": "</u>",
                      "[s]": "<s>",
                      "[/s]": "</s>",}
    bb_html_pairs.each do |bb, html|
      converted_text.gsub!(bb.to_s, html)
    end
    return converted_text
  end

  # Yes, I manually copied this from an online generator and formatted it.
  # Not gonna install a gem just to generate some pseudo-Latin.
  def self.lorem_ipsum
    "Lorem ipsum dolor sit amet, ei veniam nonumy honestatis sit, id vim nonumy impetus torquatos, " +
    "vix impetus veritus posidonium id? Et eam nonumy hendrerit constituam. Omnis aliquando eu per. " +
    "Dicta legimus graecis in cum! Prompta consulatu sit ea. Ut has affert dignissim. " +
    "Te amet vidit integre usu. Dolores consequat te vim, est cu regione graecis nominavi. " +
    "Eum cibo discere ornatus no, has et omnesque consectetuer. " +
    "Ad melius accusam consetetur qui, vide equidem minimum per te, " +
    "augue nulla ex sed. Appareat pertinacia intellegebat sea an, " +
    "ne tempor apeirian definitiones quo. " +
    "Ex paulo viris has. Clita feugait mea in, natum altera possit ei vel, " +
    "est eu atqui vivendo omittantur! An mutat tation concludaturque sea! " +
    "Exerci causae eos id, id viderer epicurei mea? " +
    "Dolorum perfecto ea mea. Ius ex nobis scripta voluptatibus, " +
    "aliquam singulis ut duo? His ne dicit iriure rationibus, " +
    "indoctum intellegat ea sit. Id possim dolores expetendis mea. " +
    "Pro consectetuer vituperatoribus at, te veri urbanitas concludaturque ius. " +
    "Eum graece lobortis at, sea eu assum interesset, quo ea nulla docendi fierent! " +
    "Cu his essent concludaturque? Clita eleifend vim eu, " +
    "ei est repudiandae suscipiantur vituperatoribus. Ex munere postea has? " +
    "Sea erant quidam in, vim unum tibique appellantur at? " +
    "Porro graece malorum mea eu, quo alia ferri admodum ea, " +
    "est ceteros mediocrem partiendo ea. " +
    "Per utamur deserunt salutandi ad, no voluptua tractatos cotidieque est, " +
    "quis doming hendrerit at nam! " +
    "Ipsum fuisset ex eos, et pri wisi rationibus reprehendunt. " +
    "Et melius delenit his. Eam ad enim probo euismod, " +
    "vix ex erant tractatos. Mei ne sint paulo suscipit, " +
    "mei iriure rationibus ea? Sea munere qualisque percipitur ei, " +
    "at sit causae aliquid deleniti. Lorem referrentur no ius, " +
    "pri cibo volumus vivendum ei, te graecis scaevola reformidans eum. " +
    "Mel assum iudico ne, ius id libris consetetur! " +
    "Ludus dolores vix te, no nec discere interesset! " +
    "Pro ad natum putant commune, pro in graeco scaevola percipitur, " +
    "eos ea quod euismod? Cu his tempor pertinax, ad homero salutandi mea. " +
    "Ut choro posidonium eos, ea omnium honestatis vim! Appetere accusamus " +
    "intellegat duo et, sed agam facer libris ea. " +
    "Harum electram inciderint in sea. Modo soleat gubergren no his. " +
    "Eos natum scripserit ei, nec an quidam oportere, sed ei atqui vituperata. " +
    "Usu at repudiare patrioque, esse concludaturque ex vix. " +
    "An mea ullum iriure, no quas nonumy sadipscing mei! " +
    "Duo senserit adversarium eu, eam ex simul decore. " +
    "Sensibus scripserit his in, ius facer diceret euismod no, " +
    "vel congue partem ullamcorper te. " +
    "Per dolor fierent no, usu eu homero vidisse propriae? " +
    "Ne eros scaevola sit. Nemore commune maiestatis vis ut, " +
    "numquam impedit est eu. Eu omnes quodsi eos, ex vide nominati vis? " +
    "Adolescens cotidieque sed ad, id sit populo aeterno oblique? " +
    "Labore perfecto quaerendum sea an? Vis no homero eleifend, " +
    "vim ceteros electram an? Eirmod impedit cotidieque cu usu." +
    "Et his numquam meliore dissentias, ius tollit apeirian ne, " +
    "an novum suavitate definitiones cum? Quo tale viris bonorum ad, " +
    "eum ex quis nusquam verterem, lorem omnesque ius ex! " +
    "Ei tation soluta graeci per, lobortis pericula repudiandae no mel. " +
    "Nominavi perfecto cu quo, ei dicta adolescens vis, case homero soleat no vis. " +
    "Ne sed aeque commune. Sed velit evertitur aliquando ad! " +
    "Meliore partiendo neglegentur quo ei, sint diceret ad per? Nam no epicuri pertinax, " +
    "quas vocent integre in his. Viris sententiae delicatissimi vim ne, " +
    "quem paulo reformidans an nec? Graeco putant percipitur in sed, " +
    "sed splendide scripserit scriptorem id. Illum bonorum accusamus eum te, " +
    "te nisl prima eripuit usu, essent scripta an vel."
  end

end
