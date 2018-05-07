%
% This file is copyright (C) 2003 Sam Noble. It may be modified so long
% as my name is not removed and the modifier adds his name to the file.
% Redistribution permitted.
%
% 27 Jan 2004	Sam Noble	Removed tocbibind dependency.
% 04 Dec 2001 	Sam Noble	Class file
% 03 Sep 1995	David Perkinson	Title Page
% Acknowledgements Page, David Perkinson & Sam Noble
% May 2005 Patrick Carlisle Table of contents chapter definition
% 2004-2005 Ben Salzberg (BTS) a variety of tweaks here and in the template
% 2015 Chester Ismay (CII) modified to create R Markdown template
%
% Oddities:
%
%   We *ASSUME* that any time \cleardoublepage is called
%  we actually want a blank back side with NO page number/heading
%
%   Minor bug -- seems to be a more general LaTeX thing:
%  If you use \frontmatter \mainmatter without any chapters inbetween
%  be prepared to have the page numbering messed up. Not a big deal,
%  but I'm not sure how to fix it.
%
%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{reedthesis}[2004/01/27 The Reed College Thesis Class]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass{book}
\RequirePackage{fancyhdr}
% Added by CII to produce nice looking code in BeginVerbatimEnvironment
\RequirePackage{fancyvrb}

% Added by CII
\usepackage{ifxetex,ifluatex}
\usepackage{fixltx2e} % provides \textsubscript
\ifnum 0\ifxetex 1\fi\ifluatex 1\fi=0 % if pdftex
  \usepackage[T1]{fontenc}
  \usepackage[utf8]{inputenc}
\else % if luatex or xelatex
  \ifxetex
    \usepackage{mathspec}
    \usepackage{xltxtra,xunicode}
  \else
    \usepackage{fontspec}
  \fi
  \defaultfontfeatures{Mapping=tex-text,Scale=MatchLowercase}
  \newcommand{\euro}{€}
\fi
% use upquote if available, for straight quotes in verbatim environments
\IfFileExists{upquote.sty}{\usepackage{upquote}}{}
% use microtype if available
\IfFileExists{microtype.sty}{%
\usepackage{microtype}
\UseMicrotypeSet[protrusion]{basicmath} % disable protrusion for tt fonts
}{}
\usepackage{color}
%\newcommand{\VerbBar}{|}
%\newcommand{\VERB}{\Verb[commandchars=\\\{\}]}
\DefineVerbatimEnvironment{verbatim}{Verbatim}{xleftmargin=-1em}
\DefineVerbatimEnvironment{Highlighting}{Verbatim}{commandchars=\\\{\}}
% Add ',fontsize=\small' for more characters per line
\usepackage{framed}
\definecolor{shadecolor}{RGB}{248,248,248}
% \newenvironment{Shaded}{\begin{snugshade}}{\end{snugshade}}
% \newcommand{\KeywordTok}[1]{\textcolor[rgb]{0.13,0.29,0.53}{\textbf{{#1}}}}
% \newcommand{\DataTypeTok}[1]{\textcolor[rgb]{0.13,0.29,0.53}{{#1}}}
% \newcommand{\DecValTok}[1]{\textcolor[rgb]{0.00,0.00,0.81}{{#1}}}
% \newcommand{\BaseNTok}[1]{\textcolor[rgb]{0.00,0.00,0.81}{{#1}}}
% \newcommand{\FloatTok}[1]{\textcolor[rgb]{0.00,0.00,0.81}{{#1}}}
% \newcommand{\ConstantTok}[1]{\textcolor[rgb]{0.00,0.00,0.00}{{#1}}}
% \newcommand{\CharTok}[1]{\textcolor[rgb]{0.31,0.60,0.02}{{#1}}}
% \newcommand{\SpecialCharTok}[1]{\textcolor[rgb]{0.00,0.00,0.00}{{#1}}}
% \newcommand{\StringTok}[1]{\textcolor[rgb]{0.31,0.60,0.02}{{#1}}}
% \newcommand{\VerbatimStringTok}[1]{\textcolor[rgb]{0.31,0.60,0.02}{{#1}}}
% \newcommand{\SpecialStringTok}[1]{\textcolor[rgb]{0.31,0.60,0.02}{{#1}}}
% \newcommand{\ImportTok}[1]{{#1}}
% \newcommand{\CommentTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{\textit{{#1}}}}
% \newcommand{\DocumentationTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{\textbf{\textit{{#1}}}}}
% \newcommand{\AnnotationTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{\textbf{\textit{{#1}}}}}
% \newcommand{\CommentVarTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{\textbf{\textit{{#1}}}}}
% \newcommand{\OtherTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{{#1}}}
% \newcommand{\FunctionTok}[1]{\textcolor[rgb]{0.00,0.00,0.00}{{#1}}}
% \newcommand{\VariableTok}[1]{\textcolor[rgb]{0.00,0.00,0.00}{{#1}}}
% \newcommand{\ControlFlowTok}[1]{\textcolor[rgb]{0.13,0.29,0.53}{\textbf{{#1}}}}
% \newcommand{\OperatorTok}[1]{\textcolor[rgb]{0.81,0.36,0.00}{\textbf{{#1}}}}
% \newcommand{\BuiltInTok}[1]{{#1}}
% \newcommand{\ExtensionTok}[1]{{#1}}
% \newcommand{\PreprocessorTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{\textit{{#1}}}}
% \newcommand{\AttributeTok}[1]{\textcolor[rgb]{0.77,0.63,0.00}{{#1}}}
% \newcommand{\RegionMarkerTok}[1]{{#1}}
% \newcommand{\InformationTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{\textbf{\textit{{#1}}}}}
% \newcommand{\WarningTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{\textbf{\textit{{#1}}}}}
% \newcommand{\AlertTok}[1]{\textcolor[rgb]{0.94,0.16,0.16}{{#1}}}
% \newcommand{\ErrorTok}[1]{\textcolor[rgb]{0.64,0.00,0.00}{\textbf{{#1}}}}
% \newcommand{\NormalTok}[1]{{#1}}

\setlength{\emergencystretch}{3em}  % prevent overfull lines
\providecommand{\tightlist}{%
  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}
% End of CII add

% This gives us rules below the headers
\AtBeginDocument{%
  \fancyhf{}
  \fancyhead[LE,RO]{\thepage}
%  \fancyhead[RE]{\slshape \leftmark}
%  \fancyhead[LO]{\slshape \rightmark}
%	The above makes your headers in all caps. If you would like different headers, choose one of the following options (be sure to remove the % symbol from both the right and left headers):
	 \fancyhead[RE]{\slshape \nouppercase \leftmark} % This makes the headers on the RIGHT side pages be italic and use lowercase With Capitals When Specified.
	\fancyhead[LO]{\slshape \nouppercase \rightmark} % This does the same thing to the LEFT side pages
%	or
%	\fancyhead[RE]{\scshape \leftmark} % The RIGHT headers will be in small caps.
%	\fancyhead[LO]{\scshape \rightmark} %  And so will the LEFT headers
  \pagestyle{fancy}

% Psych majors: You do not need the following six lines, as it conflicts with apacite, so comment them out.
  \let\oldthebibliography=\thebibliography
  \let\endoldthebibliography=\endthebibliography
  \renewenvironment{thebibliography}[1]{
    \oldthebibliography{#1}
    \addcontentsline{toc}{chapter}{\bibname}
  }{\endoldthebibliography}
 %%%%%% end of things for psych majors to comment out

  \let\oldtheindex=\theindex
  \let\endoldtheindex=\endtheindex
  \renewenvironment{theindex}{
    \oldtheindex
    \addcontentsline{toc}{chapter}{\indexname}
  }{\endoldtheindex}
}

% addition for not showing 'Chapter 1'
\def\@makechapterhead#1{%
  \vspace*{50\p@}%
  {\parindent \z@ \raggedright \normalfont
    \interlinepenalty\@M
    \Huge \bfseries
    \ifnum \c@secnumdepth >\m@ne
      \thechapter\nobreakspace
    \fi
    #1\par\nobreak
    \vskip 40\p@
  }}

% % Stolen from book.cls and modified
% \let\RToldchapter\chapter
% \renewcommand{\chapter}{\if@openright\RTcleardoublepage
% 		    \else\clearpage\fi
% 		    \thispagestyle{empty}%
% 		    \global\@topnum\z@
% 		    \@afterindenttrue
% 		    \secdef\@chapter\@schapter}

% % Stolen from book.cls PBC 5/12/05
% % Using this to actually show "Chapter 1" in TOC instead of "1"
% \def\@chapter[#1]#2{\ifnum \c@secnumdepth >\m@ne
%                        \if@mainmatter
%                          \refstepcounter{chapter}%
%                          \typeout{\@chapapp\space\thechapter.}%
%                          \addcontentsline{toc}{chapter}%
%                          {\@chapapp\space\thechapter:\space#1}%
%                        \else
%                          \addcontentsline{toc}{chapter}{#1}%
%                        \fi
%                     \else
%                       \addcontentsline{toc}{chapter}{#1}%
%                     \fi
%                     \chaptermark{#1}%
%                     \addtocontents{lof}{\protect\addvspace{10\p@}}%
%                     \addtocontents{lot}{\protect\addvspace{10\p@}}%
%                     \if@twocolumn
%                       \@topnewpage[\@makechapterhead{#2}]%
%                     \else
%                       \@makechapterhead{#2}%
%                       \@afterheading
%                     \fi}

\newcommand{\RTcleardoublepage}{
	\clearpage\if@twoside \ifodd\c@page\else
	\thispagestyle{empty}\hbox{}\newpage
	\if@twocolumn\hbox{}\newpage\fi\fi\fi}

\let\RToldcleardoublepage\cleardoublepage
\renewcommand{\cleardoublepage}{\RTcleardoublepage}

% adjust margins for binding  (changed 2007-04-24 tgp)
\setlength{\oddsidemargin}{.5in}
\setlength{\evensidemargin}{0in}
\setlength{\textwidth}{6.0in}
\setlength{\textheight}{9.0in}
\setlength\topmargin{0in}
\addtolength\topmargin{-\headheight}
\addtolength\topmargin{-\headsep}

%\setlength{\oddsidemargin}{.6in}
%\setlength{\evensidemargin}{0in}
%\setlength{\textwidth}{5.9in}
%\setlength\topmargin{0in}
%\addtolength\headheight{2.5pt}
%\addtolength\topmargin{-\headheight}
%\addtolength\topmargin{-\headsep}
%\addtolength\textheight{1in}
%\addtolength\textheight{\headheight}
%\addtolength\textheight{\headsep}

\def\degree#1{\gdef \@degree{#1}}
\def\@degree{\@latex@warning@no@line{No \noexpand\degree given}}
\def\institution#1{\gdef \@institution{#1}}
\def\@institution{\@latex@warning@no@line{No \noexpand\institution given}}
\def\division#1{\gdef \@division{#1}}
\def\@division{\@latex@warning@no@line{No \noexpand\division given}}
\def\department#1{\gdef \@department{#1}}
\def\@department{\@latex@warning@no@line{No \noexpand\department given}}
\def\thedivisionof#1{\gdef \@thedivisionof{#1}}
\def\@thedivisionof{The Division of}
\def\approvedforthe#1{\gdef \@approvedforthe{#1}}
\def\@approvedforthe{Division}
\def\advisor#1{\gdef \@advisor{#1}}
\def\@advisor{\@latex@warning@no@line{No \noexpand\advisor given}}
\def\altadvisor#1{\gdef \@altadvisor{#1} \@altadvisortrue}
\global\let\@altadvisor\@empty
\newif\if@altadvisor
\@altadvisorfalse

\renewcommand\l@chapter[2]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \vskip 1.0em \@plus\p@
    \setlength\@tempdima{1.5em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode \bfseries
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      #1\nobreak\normalfont
      \leaders\hbox{$\m@th \mkern \@dotsep mu\hbox{.}\mkern \@dotsep mu$}\hfill
      \nobreak\hb@xt@\@pnumwidth{\bfseries \hss #2}\par
      \penalty\@highpenalty
    \endgroup
  \fi}


\newenvironment{originality}{%
  \if@twocolumn
    \@restonecoltrue\onecolumn
  \else
    \@restonecolfalse
  \fi
  \chapter*{Author’s declaration of originality}
  \fontsize{12}{14}\selectfont
}{\clearpage \if@restonecol\twocolumn\fi}%

\newenvironment{abbrvs}{%
  \if@twocolumn
    \@restonecoltrue\onecolumn
  \else
    \@restonecolfalse
  \fi
  \chapter*{List of abbreviations and terms}
  \fontsize{12}{14}\selectfont
}{\clearpage \if@restonecol\twocolumn\fi}%

\newenvironment{abstract}{%
  \if@twocolumn
    \@restonecoltrue\onecolumn
  \else
    \@restonecolfalse
  \fi
  \chapter*{Abstract}
  \fontsize{12}{14}\selectfont
}{\clearpage \if@restonecol\twocolumn\fi}%

\newenvironment{annotatsioon}{%
  \if@twocolumn
    \@restonecoltrue\onecolumn
  \else
    \@restonecolfalse
  \fi
  \chapter*{Annotatsioon}
  \fontsize{12}{14}\selectfont
}{\clearpage \if@restonecol\twocolumn\fi}%

\ifx\@pdfoutput\@undefined
  \newcommand{\RTpercent}{\@percentchar\space}
  \AtBeginDvi{\special{!\RTpercent Reed College LaTeX Thesis Class 2001/12/04 SN}}
  \AtBeginDvi{\special{rawpostscript \RTpercent Reed College LaTeX Thesis Class 2001/12/04 SN}}
\else
  \AtEndDocument{\pdfinfo{/Creator	(Reed College LaTeX Thesis Class 2001/12/04 SN)}}
\fi

\fancypagestyle{alim}{
  \fancyhf{}
  \fancyfoot[C]{Tallinn 2018}
 }

\renewcommand{\maketitle}{%
  {
%------------------------------TIITELLEHT---------------------------------
  \newpage
  \begin{titlepage}
  \thispagestyle{alim}
  %\pagenumbering{gobble}
  \renewcommand{\headrulewidth}{0pt} %Eemaldab päisest horisontaalse joone
  \renewcommand{\footrulewidth}{0pt} %Eemaldab jalusest horisontaalse joone
  \headheight = 57pt %Paneb paika päise laiuse (vastavalt kompilaatori soovitusele)
  \footskip = 11pt %Jaluse ruum
  \headsep = 0pt %Vähendab päise ja teksti vahelise kauguse nullini

  \begin{center} %Tekst keskele
  \textsc{
    \begin{Large} %Tekst suurtähtedega ja suuremaks
    \@institution\\
    \end{Large} 
  }
  \@division\\

  \vspace*{5 cm} %Tekitab lehe alguse ja teksti vahele tühja ala vastava laiusega

  \@author\\[2cm]
  \begin{LARGE}
  \textsc{\@title\\[2cm]}
  \end{LARGE}
  Master's Thesis\\[2cm]
  \end{center}
  \begin{flushright} %Joondab teksti paremale
  \@advisor\\
  \@degree
  \end{flushright}
  \pagebreak %Lehe lõpp
  \end{titlepage}
  }
}

% From JSS
% Added by CII
\renewcommand{\title}[1]{\def\@title{#1}}
%\newcommand{\Shorttitle}[1]{\def\@Shorttitle{#1}}
\newcommand{\Plainauthor}[1]{\def\@Plainauthor{#1}}
\newcommand{\Abstract}[1]{\def\@Abstract{#1}}
%\newcommand{\Keywords}[1]{\def\@Keywords{#1}}
%\newcommand{\Plainkeywords}[1]{\def\@Plainkeywords{#1}}
\newcommand{\Originality}[1]{\def\Originality{#1}}
\newcommand{\Annotatsioon}[1]{\def\@Annotatsioon{#1}}
\newcommand{\Abbrvs}[1]{\def\@Abbrvs{#1}}
% End of CII add
