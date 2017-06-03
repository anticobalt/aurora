class StringConstructor

  def parent_directory(abs_path)
    # E.g. "C:\\windows\\log.txt" => "C:\\windows"
    child = abs_path.split("\\")[-1]
    span = abs_path.length - child.length - 2 # Constant to remove trailing slashes
    abs_path[0..span]
  end

  def snippet(text)
    begin
      lines = text.split("\n")
    rescue ArgumentError
      return "ERROR: invalid characters found in file. Ensure that the file is encoded in UTF-8."
    end

    if text.length < 1000 and lines.length < 20
      return text
    else
      # If text is long despite not having a lot of lines
      if text.scan(/.{1,70}/).length > lines.length
        return text[0...20*70] + (text[20*70..-1].split("\n")[0]).to_s
      # If text is short character-wise but has a lot of lines
      elsif lines.length >= 20
        return lines[0..20].join("\n")
      end
    end
  end

  def lorem_ipsum
    # Yes, I manually copied this from an online generator and formatted it.
    # Not gonna install a gem just to generate some pseudo-Latin.
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
