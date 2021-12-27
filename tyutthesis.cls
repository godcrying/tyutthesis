%%
%% This is file `thuthesis.cls',
%% generated with the docstrip utility.
%%
%% Copyright (C) 2005-2021 by Tsinghua University TUNA Association <tuna@tsinghua.edu.cn>
%% 
%% Modified by Zhenyu Li <lee_brave@outlook.com>
%%
%% This work may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3c
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%    https://www.latex-project.org/lppl.txt
%% and version 1.3c or later is part of all distributions of LaTeX
%% version 2008 or later.
%% 
%% To produce the documentation run the original source files ending with `.dtx'
%% through LaTeX.
%% 
% 命令中的@号没有什么特别的含义，跟常用的字符一样。
% 更改为原模板名称为tyutthesis
% 所有相关命令保留thu为前缀
\NeedsTeXFormat{LaTeX2e}[2017/04/15]
\ProvidesClass{tyutthesis} % 定义一个文档类
[2021/05/10 0.0.1 Taiyuan University of Technology Thesis Template]
% latex 可以用于创建命令的字符有两种：一种带@，一种不带@
% 内部命令常用@符号，外部命令不能使用@
% 在写论文时，需要重定义含有@的内部命令时，需要使用\makeatletter来使@变成普通字符
%
% 报错
% 定义了一个error
\newcommand\thu@error[1]{%
  \ClassError{thuthesis}{#1}{}%
}
% 定义了一个warning
\newcommand\thu@warning[1]{%
  \ClassWarning{thuthesis}{#1}%
}
% 定义了一个patch error
\newcommand\thu@patch@error[1]{%
  \thu@error{Failed to patch command \protect#1}%
}
% 定义了一个过时 warning
\newcommand\thu@deprecate[2]{%
  \def\thu@@tmp{#2}%
  \thu@warning{%
    The #1 is deprecated%
    \ifx\thu@@tmp\@empty\else
      . Use #2 instead%
    \fi
  }%
}
% 检查Latex kernel版本
% 不用在意
\@ifl@t@r\fmtversion{2017/04/15}{}{
  \thu@error{% 版本不对则报错
    TeX Live 2017 or later version is required to compile this document%
  }
}

% 检查编译引擎。引擎不对则报错
\RequirePackage{iftex}
\ifXeTeX\else
  \thu@error{XeLaTeX is required to compile this document}
\fi

% % 载入用于测试的配置，不存在此文件
% \InputIfFileExists{thuthesis-pdf-test-config.tex}{}{
%   \InputIfFileExists{thuthesis-log-test-config.tex}{}{}
% }

%%%%%%%%%%%%%%%%%%%%
% 定义该文档类的基本信息宏
%%%%%%%%%%%%%%%%%%%%
\hyphenation{thu-Thesis} % 指定断字方式，只能在横线处断词
\def\thuthesis{thuThesis} % 定义模板名称，便于直接使用
\def\version{0.0.1} % 指定模板版本，便于直接使用
% 导入支持key-value的包
%%%%
% 提供一个\thusetup命令支持key-value的方式来设置
% 见说明文档的实现细节
%%%%
\RequirePackage{kvdefinekeys}
\RequirePackage{kvsetkeys}
\RequirePackage{kvoptions}
% 上面这三个包用来实现选项功能
\SetupKeyvalOptions{ % 设置选项名称约定，以thu开头，详见kvoptions的文档 
  family=thu,
  prefix=thu@,% 以thu@开头
  setkeys=\kvsetkeys}

\let\thu@setup@hook\@empty
\newcommand\thusetup[1]{% 
  \let\thu@setup@hook\@empty % 不知道这个empty有啥用
  \kvsetkeys{thu}{#1}% 把\thusetup的第一个参数送给thu的handler，thu是一个family。使用上面\SetupKeyvalOptions定义的。
  \thu@setup@hook
}

%%%%%%%%%%%%%%%%%
% 以选项为例
% thesis-type = {
%   name = thesis@type,
%   choices = {
%     thesis,
%     proposal,
%   },
%   default = thesis,
% }
%%%%%%%%%%%%%%%%%
\newcommand\thu@define@key[1]{% 定义一个命令
  \kvsetkeys{thu@key}{#1}% 把\thu@define@key的第一个参数送给thu@key的handler
  % 选项定义是通过\thu@define@key来定义。此时#1就是输入的选项定义。
  % family为 thu@key
}
% 定义 thu@key 的handler
\kv@set@family@handler{thu@key}{% 定义 thu@key 的handler
  % \@namedef{指令名不带斜杠}{执行内容} 功能是通过指令名称来定义指令。因为newcommand只支持静态的命令名，不支持创建动态命名的命令。
  \@namedef{thu@#1@@name}{#1}% #1 是key， #2 是value。 这里把<key>定义为指令\thu@<key>@@name，而其内容就是key本身。对于带有"-"的key，需要将该指令定义为name的内容
  % 此时，#1为thesis-type
  % \@namedef{saveBox}{foo} 等于 \expandafter\def\csname saveBox \endcsname
  \def\thu@@default{}% key的默认值
  \def\thu@@choices{}% 选择值的默认值
  
  %%%%%
  % thu@value family
  %%%%%
  % 这里又在thu@value中定义了一个name键对应的处理规则
  \kv@define@key{thu@value}{name}{%
  % 这里的目的是为了将带“-”的选项名称设置为name所指定的名称。
    \@namedef{thu@#1@@name}{##1}% 命令内部定义命令使用##1。 
    % 这里是将名为name对应的value赋值给##1，然后又定义为thu@#1@@name命令
    % 此时family为thu@value，#1为thesis-type，##1为thesis@type
    % 即\thu@#1@@name的值为thesis@type
  }%
  
  \@namedef{thu@#1@@check}{}% 再定义两个以key动态命名的指令：check和code
  \@namedef{thu@#1@@code}{}% 定义选项名对应的代码段。
  % 以后所有该选项相关的代码都会通过\thu@option@hook放到code中

  \kv@define@key{thu@value}{choices}{% family为thu@value，key为choices
    \def\thu@@choices{##1}% 又将choices的值赋给\thu@@choices
    % \thu@@choices= {
%     thesis,
%     proposal,
%   },
    \@namedef{thu@#1@@reset}{}% 再定义两个以key动态命名的指令：reset和check
    \@namedef{thu@#1@@check}{%
      \@ifundefined{%
        ifthu@\@nameuse{thu@#1@@name}@\@nameuse{thu@\@nameuse{thu@#1@@name}}%
        % ifthu@\thu@thesis-type@@name @ \{thu@\thu@thesis-type@@name}
        % ifthu@thesis@type @ \thu@thesis@type
        % 此时，如果\thu@thesis@type 定义了，则证明thu@thesis@type @ \thu@thesis@type是已经定义过的选项，则不会执行下面的报错。
% 注意，这里的\@nameuse{thu@\@nameuse{thu@#1@@name}}是指当前设置的选项。
% 这个check只有在调用\thusetup才调用
      }{%
        \thu@error{Invalid value "#1 = \@nameuse{thu@\@nameuse{thu@#1@@name}}"}%
      }%
      \@nameuse{thu@#1@@reset}% 这个reset好像没什么用
      % 这里跟\newif 命令有关。
      % \newif\ifpaper
      % 之后就可以进行\papertrue或\paperfalse
      \@nameuse{thu@\@nameuse{thu@#1@@name}@\@nameuse{thu@\@nameuse{thu@#1@@name}}true}% 
      % 将所选的选项设置为true
    }%
  }%

  \kv@define@key{thu@value}{default}{%
    \def\thu@@default{##1}% 将default暂存到\thu@@default
  }%

  \kvsetkeys{thu@value}{#2}
  % 把value给了名为thu@value的family的handler，但是没有对应的handler，
  % 故调用\kv@define@key所规定的规则进处理
  % #2 为 thesis-type 的值
  % thesis-type = {
    %   name = thesis@type,
    %   choices = {
    %     thesis,
    %     proposal,
    %   },
    %   default = thesis,
    % }
  \@namedef{thu@\@nameuse{thu@#1@@name}}{}%
  % 这里定义\thu@thesis@type

  %%%%%%%%%%%%
  % thu@choice family
  %%%%%%%%%%%%
  % 第一个⟨choice⟩设为⟨default⟩，并且对每个⟨choice⟩定义\ifthu@⟨name⟩@⟨choice⟩
  \kv@set@family@handler{thu@choice}{%
    \ifx\thu@@default\@empty
      \def\thu@@default{##1}% 如果\thu@@default没定义，则定义为##1
    \fi
    \expandafter\newif\csname ifthu@\@nameuse{thu@#1@@name}@##1\endcsname
    % 这里出现newif，定义ifthu@thesis@type@thesis
    % 每个choice都设置了对应的if
    \expandafter\g@addto@macro\csname thu@#1@@reset\endcsname{%
      \@nameuse{thu@\@nameuse{thu@#1@@name}@##1false}%
      % 将thu@thesis@type@thesisfalse 添加到reset中
    }%
  }%
  
  \kvsetkeys@expandafter{thu@choice}{\thu@@choices}% 把choices中的内容交给thu@choice 的handler进行处理

  \expandafter\let\csname thu@\@nameuse{thu@#1@@name}\endcsname\thu@@default
  % \thu@thesis@type设置为\thu@@default，即\thu@thesis@type = thsis
  % 而\thu@@default已经拥有对应的ifthu@thesis@type@thesis
  % 则ifthu@thesis@type@ \thu@thesis@type 就是 ifthu@thesis@type@thesis

  \expandafter\ifx\csname thu@\@nameuse{thu@#1@@name}\endcsname\@empty\else
    \@nameuse{thu@#1@@check}%
  \fi
  % 如果\thu@thesis@type不为空，就进行检查

  % 定义thu family的处理方式
  \kv@define@key{thu}{#1}{% 定义thu-thesis键的处理方式
    \@namedef{thu@\@nameuse{thu@#1@@name}}{##1}%
    \@nameuse{thu@#1@@check}%
    \@nameuse{thu@#1@@code}% 执行thu@#1@@code
  }%
}
% 小结：
% 1. \kvsetkeys有两种处理方式：一种是通过\define@key或\kv@define@key来处理选项，一种是通过family的handler处理选项。
% 2. thu@key 和 thu@choice 是通过设置handler的方式实现的；thu@value和thu 是通过\kv@define@key 实现的。

%%%%%%%%%%%%%%%%%%%
% 定义接口向key添加code
%%%%%%%%%%%%%%%%%%
\newcommand\thu@option@hook[2]{% 把第二个参数放到第一个参数的code中
  \expandafter\g@addto@macro\csname thu@#1@@code\endcsname{#2}%
  % 即
}

% 定义选项
\thu@define@key{
  degree = {
    choices = {
      master,
      doctor,
    },
    default = master,
  },
  degree-type = {
    choices = {
      academic,
      professional,
    },
    name = degree@type,
  },
  % 论文主要语言
  main-language = {
    name = main@language,
    choices = {
      chinese,
      english,
    },
  },
  % 局部语言
  language = {
    choices = {
      chinese,
      english,
    },
  },
  % 字体
  system = {
    choices = {
      auto,
      mac,
      unix,
      windows,
    },
    default = auto,
  },
  fontset = {
    choices = {
      auto,
      windows,
      mac,
      ubuntu,
      fandol,
      none,
    },
    default = auto,
  },
  font = {
    choices = {
      auto,
      times,
      termes,
      stix,
      xits,
      libertinus,
      newcm,
      lm,
      newtx,
      none,
    },
    default = auto,
  },
  cjk-font = {
    name = cjk@font,
    choices = {
      auto,
      windows,
      mac,
      noto,
      fandol,
      none,
    },
    default = auto,
  },
  math-font = {
    name = math@font,
    choices = {
      auto,
      stix,
      xits,
      libertinus,
      newcm,
      lm,
      newtx,
      none,
    },
    default = auto,
  },
  math-style = {
    name = math@style,
    choices = {
      GB,
      ISO,
      TeX,
    },
  },
  uppercase-greek = {
    name = uppercase@greek,
    choices = {
      italic,
      upright,
    },
  },
  less-than-or-equal = {
    name = leq,
    choices = {
      slanted,
      horizontal,
    },
  },
  integral = {
    choices = {
      upright,
      slanted,
    },
  },
  integral-limits = {
    name = integral@limits,
    choices = {
      true,
      false,
    },
  },
  partial = {
    choices = {
      upright,
      italic,
    },
  },
  math-ellipsis = {
    name = math@ellipsis,
    choices = {
      centered,
      lower,
      AMS,
    },
  },
  real-part = {
    name = real@part,
    choices = {
      roman,
      fraktur,
    },
  },
  % 打印版还是电子版
  output = {
    choices = {
      print,
      electronic,
    },
    default = print,
  },
}

% 新建一个处理degree的命令
% 根据不同学位设置不同的值
% 然后放到学位设定的hook中

% 把\thu@set@graduate放到thu@degree@@code 中

% 设置默认openany，即新的一章从什么地方开始，
% 默认openright即奇数页面开始
\DeclareBoolOption[false]{openright} % 定义boolean openright选项
\DeclareComplementaryOption{openany}{openright} % 定义对应的互斥选项

% raggedbottom 选项默认打开，
% 即所有页面按顶部对齐，下部留出空白，
% 参见一份（不太）简短的LATEX2e介绍
\DeclareBoolOption[true]{raggedbottom} % 定义boolean raggedbottom选项

% 模板基于ctexbook宏包，其他未定义的选项都传递给该宏包。
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{ctexbook}}
% 解析用户传递的选项，并加载ctexbook
\ProcessKeyvalOptions*

% 设置默认openany
\ifthu@openright % 注意：这里的前缀thu是使用SetupKeyvalOptions设置的，位置在老前面（搜索查看）
  \PassOptionsToClass{openright}{book} % ctex是基于book类实现的
\else
  \PassOptionsToClass{openany}{book}
\fi

% unicode-math和newtx都不需要fontspec设置数学字体
\PassOptionsToPackage{no-math}{fontspec}
% 到此选项基本设置完毕
% 总结一下：
% 1. 所有选项都以thu@开头。
% 2. 只有openright和raggedbottom使用DeclarexxxOption类型的命令定义
% 3. 所有通过\thu@define@key设置的选项都有一个对应的hook
% 4. 所有选项都设置了\thu@<name>类型的命令，且值为<choice>的第一个值。
% 5. 所有选项的可能值都有对应的\thu@<name>@<choice>
% 6. 所有选项对应的所有可能值都有对应的\ifthu@<name>@<choice>，且非默认选项初始为：\thu@<name>@<choice>false

% 使用ctexbook宏包
\LoadClass[a4paper,UTF8,zihao=-4,scheme=plain,fontset=none]{ctexbook}[2017/04/01]

% 引用的宏包
\RequirePackage{etoolbox}
\RequirePackage{filehook}
\RequirePackage{xparse}
\RequirePackage{geometry}%
\RequirePackage{fancyhdr} % 页眉页脚设置
\RequirePackage{titletoc}
\RequirePackage{notoccite} % 利用notoccite避免目录中引用编号混乱
\RequirePackage{amsmath} % 更漂亮的公式
\RequirePackage{graphicx}
\RequirePackage[center]{caption}
%\RequirePackage[labelformat=simple]{subcaption} % 修改：使用subfloat包
\RequirePackage[list=off]{bicaption} % 修改：太原理工大学要求中英文双语标题，list=off可以在插图列表清单中不显示英文标题

\DeclareCaptionOption{bi-first}[]{
	\def\tablename{表}
	\def\figurename{图}}
\DeclareCaptionOption{bi-second}[]{
	\def\tablename{Table}
	\def\figurename{Fig.}}
\captionsetup[bi-first]{bi-first}
\captionsetup[bi-second]{bi-second}

\RequirePackage{pdfpages}
\includepdfset{fitpaper=true} % 这个是pdfpages的设置命令
% 列表环境
\RequirePackage[shortlabels]{enumitem}
\RequirePackage{environ}

% 禁止latex自动调整页面底部空白
\ifthu@raggedbottom
  \RequirePackage[bottom,perpage,hang]{footmisc}
  \raggedbottom
\else
  \RequirePackage[perpage,hang]{footmisc}
\fi

% 汉字下划线的对齐功能，见实现细节
\RequirePackage{xeCJKfntef}
\RequirePackage{soul}
% 数组
\RequirePackage{array}
% 三线表
\RequirePackage{booktabs}
\RequirePackage{url}

% 自动调用natbib
\AtEndPreamble{
  \@ifpackageloaded{biblatex}{}{
    \@ifpackageloaded{apacite}{}{
      \RequirePackage{natbib}
    }
  }
}
\AtEndOfPackageFile*{natbib}{
  \@ifpackageloaded{apacite}{}{
    \RequirePackage{bibunits}
  }
}

% 冲突包报错
\newcommand\thu@package@conflict[2]{%
  \AtEndOfPackageFile*{#1}{%
    \AtBeginOfPackageFile*{#2}{%
      \thu@error{The "#2" package is incompatible with "#1"}%
    }%
  }%
}
\thu@package@conflict{biblatex}{bibunits}
\thu@package@conflict{biblatex}{chapterbib}
\thu@package@conflict{biblatex}{cite}
\thu@package@conflict{biblatex}{multibib}
\thu@package@conflict{biblatex}{natbib}

\thu@package@conflict{bibunits}{biblatex}
\thu@package@conflict{bibunits}{chapterbib}
\thu@package@conflict{bibunits}{multibib}

\thu@package@conflict{unicode-math}{amscd}
\thu@package@conflict{unicode-math}{amsfonts}
\thu@package@conflict{unicode-math}{amssymb}
\thu@package@conflict{unicode-math}{bbm}
\thu@package@conflict{unicode-math}{bm}
\thu@package@conflict{unicode-math}{eucal}
\thu@package@conflict{unicode-math}{eufrak}
\thu@package@conflict{unicode-math}{mathrsfs}
\thu@package@conflict{unicode-math}{newtxmath}
\thu@package@conflict{unicode-math}{upgreek}

\thu@package@conflict{natbib}{biblatex}
\thu@package@conflict{natbib}{cite}

\thu@package@conflict{newtxmath}{amsfonts}
\thu@package@conflict{newtxmath}{amssymb}
\thu@package@conflict{newtxmath}{unicode-math}
\thu@package@conflict{newtxmath}{upgreek}

% mathtools需要在unicode-math前载入
\AtBeginOfPackageFile*{mathtools}{
	\@ifpackageloaded{unicode-math}{
		\thu@error{The "mathtools" package should be loaded before setting "math-font"}
	}{}
}%
% amsthm需要在newtx前载入，参考newtx的文档
% newtx可以提供更美观的矩阵，newtx字体是Times New Roman风格
\AtBeginOfPackageFile*{amsthm}{
  \@ifpackageloaded{newtxmath}{
    \thu@error{The "amsthm" package should be loaded before setting "newtxmath"}
  }{}
}%

%%%%%%%%%%%%%%%%%%%%
% 页面设置
%%%%%%%%%%%%%%%%%%%%
\geometry{
  paper          = a4paper,  % 210 * 297mm
  marginparwidth = 2cm,
  marginparsep   = 0.5cm,
}
\newcommand\thu@set@geometry{%
    \geometry{ % 修改：太原理工大学要求 上下2.54cm，左3cm 右2cm，模板给出的页眉顶端距为1.5cm，页脚底端距1.75cm。微调页眉高度
		top        = 2.54cm,
		bottom     = 2.54cm,
		left       = 3cm,
		right      = 2cm,
		headheight = 0.37cm, % 五号字高度0.37mm
		headsep    = 0.67cm, % 要保证top-headheight-headsep=1.5
		footskip   = 0.79cm, % 要保证bottom-footskip=1.75
    }%
}
% 先执行该命令生成对应\geometry的指令，然后加入hook中
\thu@set@geometry
\thu@option@hook{degree}{\thu@set@geometry} % 加入到对应hook中
\thu@option@hook{output}{\thu@set@geometry}

% 语言设置
\thusetup{main-language=\thu@language}% 调用\thusetup 命令，设置\thu@language
\let\thu@main@language\thu@language
\thu@option@hook{language}{%
  \ifx\@begindocumenthook\@undefined\else
    \thusetup{main-language=\thu@language}%
    \let\thu@main@language\thu@language
  \fi
}
\newcommand\thu@reset@main@language{%
  \thusetup{language = \thu@main@language}%
  \let\thu@language\thu@main@language
}

%%%%%%%%%%%%%%%%%%%%%%%
% 根据语言设置各章节的名称
% 导言区设置论文主语言会自动更改章节所用语言
%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\thu@set@chapter@names{%
  \ifthu@main@language@chinese
    \def\thu@comments@name{指导教师学术评语}%
    \def\bibname{参考文献}%
    \def\appendixname{附录}%
    \def\indexname{索引}%
    \def\thu@resolution@name{答辩委员会决议书}%
	\def\listfigurename{插图清单}%
	\def\listtablename{附表清单}%
	\def\thu@list@figure@table@name{插图和附表清单}%
	\def\thu@list@algorithm@name{算法清单}%
	\def\listequationname{公式清单}%
	\def\thu@acknowledgements@name{致\quad 谢}%
	\def\contentsname{目\quad 录}%
	\def\thu@denotation@name{符号和缩略语说明}%
	\def\thu@resume@name{攻读学位期间取得的研究成果}%
  \else
    \ifthu@main@language@english
      \def\thu@comments@name{Comments from Thesis Supervisor}%
      \def\thu@resolution@name{Resolution of Thesis Defense Committee}%
      \def\indexname{Index}%
        \def\contentsname{Table of Contents}%
        \def\listfigurename{List of Figures}%
        \def\listtablename{List of Tables}%
        \def\thu@list@figure@table@name{List of Figures and Tables}%
        \def\thu@list@algorithm@name{List of Algorithms}%
        \def\listequationname{List of Equations}%
        \def\thu@denotation@name{List of Symbols and Acronyms}%
        \def\bibname{References}%
        \def\appendixname{Appendix}%
        \def\thu@acknowledgements@name{Acknowledgements}%
        \def\thu@resume@name{Resume}%
    \fi
  \fi
}
\thu@set@chapter@names
\thu@option@hook{degree}{\thu@set@chapter@names}
\thu@option@hook{main-language}{\thu@set@chapter@names}

% 这部分名称在正文中局部地修改语言时会发生变化，
% 比如英文摘要、本科生附录的阅读报告
\newcommand\thu@set@names{%
  \ifthu@language@chinese
    \ctexset{
      figurename = 图,
      tablename  = 表,
    }%
    \def\thu@algorithm@name{算法}%
    \def\thu@equation@name{公式}%
    \def\thu@assumption@name{假设}%
    \def\thu@definition@name{定义}%
    \def\thu@proposition@name{命题}%
    \def\thu@lemma@name{引理}%
    \def\thu@theorem@name{定理}%
    \def\thu@axiom@name{公理}%
    \def\thu@corollary@name{推论}%
    \def\thu@exercise@name{练习}%
    \def\thu@example@name{例}%
    \def\thu@remark@name{注释}%
    \def\thu@problem@name{问题}%
    \def\thu@conjecture@name{猜想}%
    \def\thu@proof@name{证明}%
    \def\thu@theorem@separator{：}%
  \else
    \ifthu@language@english
      \ctexset{
        figurename = {Figure},
        tablename  = {Table},
      }%
      \def\thu@algorithm@name{Algorithm}%
      \def\thu@equation@name{Equation}%
      \def\thu@assumption@name{Assumption}%
      \def\thu@definition@name{Definition}%
      \def\thu@proposition@name{Proposition}%
      \def\thu@lemma@name{Lemma}%
      \def\thu@theorem@name{Theorem}%
      \def\thu@axiom@name{Axiom}%
      \def\thu@corollary@name{Corollary}%
      \def\thu@exercise@name{Exercise}%
      \def\thu@example@name{Example}%
      \def\thu@remark@name{Remark}%
      \def\thu@problem@name{Problem}%
      \def\thu@conjecture@name{Conjecture}%
      \def\thu@proof@name{Proof}%
      \def\thu@theorem@separator{: }%
    \fi
  \fi
}
\thu@set@names
\thu@option@hook{language}{\thu@set@names}

% 带圈数字和星号使用中文字体
\xeCJKDeclareCharClass{CJK}{"2460 -> "2473}
\xeCJKDeclareCharClass{CJK}{"2605}

% Unicode中存在中西标点混用，需要进一步设置
\newcommand\thu@set@punctuations{%
  \ifthu@language@chinese
    \xeCJKDeclareCharClass{FullLeft}{"2018, "201C}%
    \xeCJKDeclareCharClass{FullRight}{
      "00B7, "2019, "201D, "2013, "2014, "2025, "2026, "2E3A,
    }%
  \else
    \ifthu@language@english
      \xeCJKDeclareCharClass{HalfLeft}{"2018, "201C}%
      \xeCJKDeclareCharClass{HalfRight}{
        "00B7, "2019, "201D, "2013, "2014, "2025, "2026, "2E3A,
      }%
    \fi
  \fi
}
\thu@set@punctuations
\thu@option@hook{language}{\thu@set@punctuations}

%%%%%%%%%%%%%%%%%%%%
% 定义字体
%%%%%%%%%%%%%%%%%%%%
% 字号\normalsize为12bp，行距为20bp
% 其他\small \big 等等可以看情况修改
\renewcommand\normalsize{%
  \@setfontsize\normalsize{12bp}{20bp}%
  \abovedisplayskip 6bp%
  \abovedisplayshortskip 6bp%
  \belowdisplayshortskip 6bp%
  \belowdisplayskip \abovedisplayskip
}
\normalsize
\ifx\MakeRobust\@undefined \else
    \MakeRobust\normalsize
\fi
\DeclareRobustCommand\small{%
   \@setfontsize\small{10.5bp}{17.5bp}%
   \abovedisplayskip 6bp%
   \abovedisplayshortskip 6bp%
   \belowdisplayshortskip 6bp%
   \def\@listi{\leftmargin\leftmargini
               \topsep \z@skip
               \parsep \z@skip
               \itemsep \z@skip}%
   \belowdisplayskip \abovedisplayskip
}
\DeclareRobustCommand\footnotesize{%
   \@setfontsize\footnotesize{9bp}{15bp}%
   \abovedisplayskip 6bp%
   \abovedisplayshortskip 6bp%
   \belowdisplayshortskip 6bp%
   \def\@listi{\leftmargin\leftmargini
               \topsep \z@skip
               \parsep \z@skip
               \itemsep \z@skip}%
   \belowdisplayskip \abovedisplayskip
}
\DeclareRobustCommand\scriptsize{\@setfontsize\scriptsize{7.5bp}{12.5bp}}
\DeclareRobustCommand\tiny{\@setfontsize\tiny{6.5bp}{10.83bp}}
\DeclareRobustCommand\large{\@setfontsize\large{15bp}{25bp}}
\DeclareRobustCommand\Large{\@setfontsize\Large{18bp}{30bp}}
\DeclareRobustCommand\LARGE{\@setfontsize\LARGE{22bp}{36.67bp}}
\DeclareRobustCommand\huge{\@setfontsize\huge{24bp}{40bp}}
\DeclareRobustCommand\Huge{\@setfontsize\Huge{26bp}{43.33bp}}

% 字号定义
\def\thu@def@fontsize#1#2{%
  \expandafter\newcommand\csname #1\endcsname[1][1.3]{%
    \fontsize{#2}{##1\dimexpr #2}\selectfont}}
\thu@def@fontsize{chuhao}{42bp}
\thu@def@fontsize{xiaochu}{36bp}
\thu@def@fontsize{yihao}{26bp}
\thu@def@fontsize{xiaoyi}{24bp}
\thu@def@fontsize{erhao}{22bp}
\thu@def@fontsize{xiaoer}{18bp}
\thu@def@fontsize{sanhao}{16bp}
\thu@def@fontsize{xiaosan}{15bp}
\thu@def@fontsize{sihao}{14bp}
\thu@def@fontsize{xiaosi}{12bp}
\thu@def@fontsize{wuhao}{10.5bp}
\thu@def@fontsize{xiaowu}{9bp}
\thu@def@fontsize{liuhao}{7.5bp}
\thu@def@fontsize{xiaoliu}{6.5bp}
\thu@def@fontsize{qihao}{5.5bp}
\thu@def@fontsize{bahao}{5bp}

% 检测系统类型
\ifthu@system@auto
  \IfFileExists{/System/Library/Fonts/Menlo.ttc}{
    \thusetup{system = mac}
  }{
    \IfFileExists{/dev/null}{
      \IfFileExists{null:}{
        \thusetup{system = windows}
      }{
        \thusetup{system = unix}
      }
    }{
      \thusetup{system = windows}
    }
  }
\fi
% 使用fontspec配置字体
\ifthu@fontset@auto
  \ifthu@system@windows
    \thusetup{fontset = windows}
  \else
    \IfFontExistsTF{SimSun}{
      \thusetup{fontset = windows}
    }{
      \ifthu@system@mac
        \thusetup{fontset = mac}
      \else
        \IfFontExistsTF{Noto Serif CJK SC}{
          \thusetup{fontset = ubuntu}
        }{
          \thusetup{fontset = fandol}
        }
      \fi
    }
  \fi
\fi
% 设置西文字体
\ifthu@font@auto
  \ifthu@fontset@windows
    \thusetup{font=times}
  \else
    \ifthu@fontset@mac
      \thusetup{font=times}
    \else
      \thusetup{font=termes}
    \fi
  \fi
\fi
% Times New Roman + Arial
\newcommand\thu@set@font@times{%
  \setmainfont{Times New Roman}%
  \setsansfont{Arial}%
  \ifthu@system@mac
    \setmonofont{Menlo}[Scale = MatchLowercase]%
  \else
    \setmonofont{Courier New}[Scale = MatchLowercase]%
  \fi
}
% 
% 各种字体设置：共700多行代码
% TeX Gyre Termes
\newcommand\thu@set@font@termes{%
  \setmainfont{texgyretermes}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
  ]%
  \thu@set@texgyre@sans@mono
}
\newcommand\thu@set@texgyre@sans@mono{%
  \setsansfont{texgyreheros}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
  ]%
  \setmonofont{texgyrecursor}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
    Scale          = MatchLowercase,
    Ligatures      = CommonOff,
  ]%
}
% STIX Two字体
\let\thu@font@family@stix\@empty
\newcommand\thu@set@stix@names{%
  \ifx\thu@font@family@stix\@empty
    \IfFontExistsTF{STIXTwoText-Regular.otf}{%
      \gdef\thu@font@family@stix{STIXTwoText}%
      \gdef\thu@font@name@stix@math{STIXTwoMath-Regular}%
    }{%
      \gdef\thu@font@family@stix{STIX2Text}%
      \gdef\thu@font@name@stix@math{STIX2Math}%
    }%
  \fi
}
\newcommand\thu@set@font@stix{%
  \thu@set@stix@names
  \setmainfont{\thu@font@family@stix}[
    Extension      = .otf,
    UprightFont    = *-Regular,
    BoldFont       = *-Bold,
    ItalicFont     = *-Italic,
    BoldItalicFont = *-BoldItalic,
  ]%
  \thu@set@texgyre@sans@mono
}
% XITS字体
\let\thu@font@family@xits\@empty
\newcommand\thu@set@xits@names{%
  \ifx\thu@font@family@xits\@empty
    \IfFontExistsTF{XITSMath-Regular.otf}{%
      \gdef\thu@font@family@xits{XITS}%
      \gdef\thu@font@style@xits@rm{Regular}%
      \gdef\thu@font@style@xits@bf{Bold}%
      \gdef\thu@font@style@xits@it{Italic}%
      \gdef\thu@font@style@xits@bfit{BoldItalic}%
      \gdef\thu@font@name@xits@math{XITSMath-Regular}%
    }{%
      \gdef\thu@font@family@xits{xits}%
      \gdef\thu@font@style@xits@rm{regular}%
      \gdef\thu@font@style@xits@bf{bold}%
      \gdef\thu@font@style@xits@it{italic}%
      \gdef\thu@font@style@xits@bfit{bolditalic}%
      \gdef\thu@font@name@xits@math{xits-math}%
    }%
  \fi
}
\newcommand\thu@set@font@xits{%
  \thu@set@xits@names
  \setmainfont{\thu@font@family@xits}[
    Extension      = .otf,
    UprightFont    = *-\thu@font@style@xits@rm,
    BoldFont       = *-\thu@font@style@xits@bf,
    ItalicFont     = *-\thu@font@style@xits@it,
    BoldItalicFont = *-\thu@font@style@xits@bfit,
  ]%
  \thu@set@texgyre@sans@mono
}
% Libertinus字体
\let\thu@font@family@libertinus\@empty
\newcommand\thu@set@libertinus@names{%
  \ifx\thu@font@family@libertinus\@empty
    \IfFontExistsTF{LibertinusSerif-Regular.otf}{%
      \gdef\thu@font@family@libertinus@serif{LibertinusSerif}%
      \gdef\thu@font@family@libertinus@sans{LibertinusSans}%
      \gdef\thu@font@name@libertinus@math{LibertinusMath-Regular}%
      \gdef\thu@font@style@libertinus@rm{Regular}%
      \gdef\thu@font@style@libertinus@bf{Bold}%
      \gdef\thu@font@style@libertinus@it{Italic}%
      \gdef\thu@font@style@libertinus@bfit{BoldItalic}%
    }{%
      \gdef\thu@font@family@libertinus@serif{libertinusserif}%
      \gdef\thu@font@family@libertinus@sans{libertinussans}%
      \gdef\thu@font@name@libertinus@math{libertinusmath-regular}%
      \gdef\thu@font@style@libertinus@rm{regular}%
      \gdef\thu@font@style@libertinus@bf{bold}%
      \gdef\thu@font@style@libertinus@it{italic}%
      \gdef\thu@font@style@libertinus@bfit{bolditalic}%
    }%
  \fi
}
\newcommand\thu@set@font@libertinus{%
  \thu@set@libertinus@names
  \setmainfont{\thu@font@family@libertinus@serif}[
    Extension      = .otf,
    UprightFont    = *-\thu@font@style@libertinus@rm,
    BoldFont       = *-\thu@font@style@libertinus@bf,
    ItalicFont     = *-\thu@font@style@libertinus@it,
    BoldItalicFont = *-\thu@font@style@libertinus@bfit,
  ]%
  \setsansfont{\thu@font@family@libertinus@sans}[
    Extension      = .otf,
    UprightFont    = *-\thu@font@style@libertinus@rm,
    BoldFont       = *-\thu@font@style@libertinus@bf,
    ItalicFont     = *-\thu@font@style@libertinus@it,
  ]%
  \setmonofont{lmmonolt10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
  ]%
}
% New Computer Modern
\newcommand\thu@set@font@newcm{%
  \setmainfont{NewCM10}[
    Extension      = .otf,
    UprightFont    = *-Book,
    BoldFont       = *-Bold,
    ItalicFont     = *-BookItalic,
    BoldItalicFont = *-BoldItalic,
  ]%
  \setsansfont{NewCMSans10}[
    Extension         = .otf,
    UprightFont       = *-Book,
    BoldFont          = *-Bold,
    ItalicFont        = *-BookOblique,
    BoldItalicFont    = *-BoldOblique,
  ]%
  \setmonofont{NewCMMono10}[
    Extension           = .otf,
    UprightFont         = *-Book,
    ItalicFont          = *-BookItalic,
    BoldFont            = *-Bold,
    BoldItalicFont      = *-BoldOblique,
  ]%
}
% Latin Modern
\newcommand\thu@set@font@lm{%
  \setmainfont{lmroman10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
  ]%
  \setsansfont{lmsans10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
  ]%
  \setmonofont{lmmonolt10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
  ]%
}
\newcommand\thu@set@font@newtx{%
  \RequirePackage{newtxtext}%
}
\newcommand\thu@set@font{%
  \@nameuse{thu@set@font@\thu@font}%
}
\thu@set@font
\thu@option@hook{font}{\thu@set@font}

% 中文字体
\ifthu@cjk@font@auto
  \ifthu@fontset@mac
    \thusetup{cjk-font = mac}
  \else
    \ifthu@fontset@windows
      \thusetup{cjk-font = windows}
    \else
      \ifthu@fontset@ubuntu
        \thusetup{cjk-font = noto}
      \else
        \thusetup{cjk-font = fandol}
      \fi
    \fi
  \fi
\fi
% Windows的中易字体
\newcommand\thu@set@cjk@font@windows{%
  \xeCJKsetup{EmboldenFactor=3}%
  \setCJKmainfont{SimSun}[
    AutoFakeBold = true,
    ItalicFont   = KaiTi,
  ]%
  \setCJKsansfont{SimHei}[AutoFakeBold]%
  \setCJKmonofont{FangSong}%
  \setCJKfamilyfont{zhsong}{SimSun}[AutoFakeBold]%
  \setCJKfamilyfont{zhhei}{SimHei}[AutoFakeBold]%
  \setCJKfamilyfont{zhkai}{KaiTi}[AutoFakeBold]% 修改：太原理工要用粗楷体
  \setCJKfamilyfont{zhfs}{FangSong}%
}
% macOS的华文字体
\newcommand\thu@set@cjk@font@mac{%
  \defaultCJKfontfeatures{}%
  \setCJKmainfont{Songti SC}[
    UprightFont    = * Light,
    BoldFont       = * Bold,
    ItalicFont     = Kaiti SC Regular,
    BoldItalicFont = Kaiti SC Bold,
  ]%
  \setCJKsansfont{Heiti SC}[
    UprightFont    = * Light,
    BoldFont       = * Medium,
  ]%
  \setCJKmonofont{STFangsong}
  \setCJKfamilyfont{zhsong}{Songti SC}[
    UprightFont    = * Light,
    BoldFont       = * Bold,
  ]%
  \setCJKfamilyfont{zhhei}{Heiti SC}[
    UprightFont    = * Light,
    BoldFont       = * Medium,
  ]%
  \setCJKfamilyfont{zhfs}{STFangsong}%
  \setCJKfamilyfont{zhkai}{Kaiti SC}[
    UprightFont    = * Regular,
    BoldFont       = * Bold,
  ]%
  \setCJKfamilyfont{zhli}{Baoli SC}%
  \setCJKfamilyfont{zhyuan}{Yuanyi SC}[
    UprightFont    = * Light,
    BoldFont       = * Bold,
  ]%
}
% 思源字体。注意Noto CJK的regular字重名字不带“Regular”
\newcommand\thu@set@cjk@font@noto{%
  \defaultCJKfontfeatures{}%
  \setCJKmainfont{Noto Serif CJK SC}[
    UprightFont    = * Light,
    BoldFont       = * Bold,
    ItalicFont     = FandolKai-Regular,
    ItalicFeatures = {Extension = .otf},
    Script         = CJK,
  ]%
  \setCJKsansfont{Noto Sans CJK SC}[
    BoldFont       = * Medium,
    Script         = CJK,
  ]%
  \setCJKmonofont{Noto Sans Mono CJK SC}[
    Script         = CJK,
  ]%
  \setCJKfamilyfont{zhsong}{Noto Serif CJK SC}[
    UprightFont    = * Light,
    UprightFont    = * Bold,
    Script         = CJK,
  ]%
  \setCJKfamilyfont{zhhei}{Noto Sans CJK SC}[
    BoldFont       = * Medium,
    Script         = CJK,
  ]%
  \setCJKfamilyfont{zhfs}{FandolFang}[
    Extension      = .otf,
    UprightFont    = *-Regular,
  ]%
  \setCJKfamilyfont{zhkai}{FandolKai}[
    Extension      = .otf,
    UprightFont    = *-Regular,
  ]%
}
% Fandol字体
\newcommand\thu@set@cjk@font@fandol{%
  \defaultCJKfontfeatures{}%
  \setCJKmainfont{FandolSong}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
    ItalicFont  = FandolKai-Regular,
    ItalicFeatures = {Extension = .otf},
  ]%
  \setCJKsansfont{FandolHei}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
  ]%
  \setCJKmonofont{FandolFang}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
  \setCJKfamilyfont{zhsong}{FandolSong}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
  ]%
  \setCJKfamilyfont{zhhei}{FandolHei}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
  ]%
  \setCJKfamilyfont{zhfs}{FandolFang}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
  \setCJKfamilyfont{zhkai}{FandolKai}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
}
\ifthu@cjk@font@none\else
  \providecommand\songti{\CJKfamily{zhsong}}
  \providecommand\heiti{\CJKfamily{zhhei}}
  \providecommand\fangsong{\CJKfamily{zhfs}}
  \providecommand\kaishu{\CJKfamily{zhkai}}
\fi
\newcommand\thu@set@cjk@font{%
  \@nameuse{thu@set@cjk@font@\thu@cjk@font}%
}
\thu@set@cjk@font
\thu@option@hook{cjk-font}{\thu@set@cjk@font}

%%%%%%%%%%%%%%%%%%
% 数学字体
%%%%%%%%%%%%%%%%%%
% 使用 unicode-math 配置数学符号格式
\newcommand\thu@set@math@style{%
  \ifthu@math@style@TeX
    \thusetup{
      uppercase-greek    = upright,
      less-than-or-equal = horizontal,
      integral           = upright,%slanted, 
      integral-limits    = false,
      partial            = italic,
      math-ellipsis      = AMS,
      real-part          = fraktur,
    }%
  \else
    \thusetup{
      uppercase-greek = italic,
      integral        = upright,
      integral-limits = false, % 修改：原来是true，积分上下限位于积分号正上/下方，太丑了
      partial         = upright,
      real-part       = roman,
    }%
    \ifthu@math@style@ISO
      \thusetup{
        less-than-or-equal = horizontal,
        math-ellipsis      = lower,
      }%
    \else
      \ifthu@math@style@GB
        \thusetup{
          less-than-or-equal = slanted,
          math-ellipsis      = centered,
        }%
      \fi
    \fi
  \fi
}
\ifthu@main@language@chinese
  \thusetup{math-style=GB}%
\else
  \thusetup{math-style=TeX}%
\fi
\thu@set@math@style
\thu@option@hook{math-style}{\thu@set@math@style}
\thu@option@hook{main-language}{%
  \ifthu@main@language@chinese
    \thusetup{math-style=GB}%
  \else
    \thusetup{math-style=TeX}%
  \fi
}
% 针对unicode-math逐项配置数学符号。
\newcommand\thu@set@unimath@leq{%
  \ifthu@leq@horizontal
    \ifx\@begindocumenthook\@undefined
      \let\le\thu@save@leq
      \let\ge\thu@save@geq
      \let\leq\thu@save@leq
      \let\geq\thu@save@geq
    \else
      \AtBeginDocument{%
        \let\le\thu@save@leq
        \let\ge\thu@save@geq
        \let\leq\thu@save@leq
        \let\geq\thu@save@geq
      }%
    \fi
  \else
    \ifthu@leq@slanted
      \ifx\@begindocumenthook\@undefined
        \let\le\leqslant
        \let\ge\geqslant
        \let\leq\leqslant
        \let\geq\geqslant
      \else
        \AtBeginDocument{%
          \let\le\leqslant
          \let\ge\geqslant
          \let\leq\leqslant
          \let\geq\geqslant
        }%
      \fi
    \fi
  \fi
}
\newcommand\thu@set@unimath@integral@limits{%
  \ifthu@integral@limits@true
    \removenolimits{%
      \int\iint\iiint\iiiint\oint\oiint\oiiint
      \intclockwise\varointclockwise\ointctrclockwise\sumint
      \intbar\intBar\fint\cirfnint\awint\rppolint
      \scpolint\npolint\pointint\sqint\intlarhk\intx
      \intcap\intcup\upint\lowint
    }%
  \else
    \addnolimits{%
      \int\iint\iiint\iiiint\oint\oiint\oiiint
      \intclockwise\varointclockwise\ointctrclockwise\sumint
      \intbar\intBar\fint\cirfnint\awint\rppolint
      \scpolint\npolint\pointint\sqint\intlarhk\intx
      \intcap\intcup\upint\lowint
    }%
  \fi
}
\newcommand\thu@set@unimath@ellipsis{%
  \ifthu@math@ellipsis@centered
    \DeclareRobustCommand\mathellipsis{\mathinner{\unicodecdots}}%
  \else
    \DeclareRobustCommand\mathellipsis{\mathinner{\unicodeellipsis}}%
  \fi
}
\newcommand\thu@set@unimath@real@part{%
  \ifthu@real@part@roman
    \AtBeginDocument{%
      \def\Re{\operatorname{Re}}%
      \def\Im{\operatorname{Im}}%
    }%
  \else
    \AtBeginDocument{%
      \let\Re\thu@save@Re
      \let\Im\thu@save@Im
    }%
  \fi
}
\newcommand\thu@set@unimath@style{%
  \ifthu@uppercase@greek@upright
    \unimathsetup{math-style = TeX}%
  \else
    \ifthu@uppercase@greek@italic
      \unimathsetup{math-style = ISO}%
    \fi
  \fi
  \ifthu@math@style@TeX
    \unimathsetup{bold-style = TeX}%
  \else
    \unimathsetup{bold-style = ISO}%
  \fi
  \thu@set@unimath@leq
  \thu@set@unimath@integral@limits
  \ifthu@partial@upright
    \unimathsetup{partial = upright}%
  \else
    \ifthu@partial@italic
      \unimathsetup{partial = italic}%
    \fi
  \fi
  \thu@set@unimath@ellipsis
  \thu@set@unimath@real@part
}
\newcommand\thu@qed{\rule{1ex}{1ex}}
\newcommand\thu@load@unimath{%
  \@ifpackageloaded{unicode-math}{}{%
    \RequirePackage{unicode-math}%
    \AtBeginDocument{%
      \let\thu@save@leq\leq
      \let\thu@save@geq\geq
      \let\thu@save@Re\Re
      \let\thu@save@Im\Im
    }% 兼容旧的粗体命令：bm的\bm 和 amsmath \boldsymbol
    \DeclareRobustCommand\bm[1]{{\symbfit{##1}}}%
    \DeclareRobustCommand\boldsymbol[1]{{\symbfit{##1}}}%
    % 兼容 amsfonts 和 amssymb 中的一些命令。

    \newcommand\square{\mdlgwhtsquare}%
    \newcommand\blacksquare{\mdlgblksquare}%
    \AtBeginDocument{%
      \renewcommand\checkmark{\ensuremath{✓}}%
    }%
  %  兼容 amsthm 的 \qedsymbol。

    \renewcommand\thu@qed{\ensuremath{\QED}}%
  }%
}

% STIX Two Math
\newcommand\thu@set@math@font@stix{%
  \thu@set@stix@names
  \setmathfont{\thu@font@name@stix@math}[
    Extension    = .otf,
    StylisticSet = \thu@xits@integral@stylistic@set,
  ]%
  \setmathfont{\thu@font@name@stix@math}[
    Extension    = .otf,
    StylisticSet = 1,
    range        = {scr,bfscr},
  ]%
}

% XITS Math
\newcommand\thu@xits@integral@stylistic@set{%
  \ifthu@integral@upright
    8%
  \fi
}
\newcommand\thu@set@math@font@xits{%
  \thu@set@xits@names
  \setmathfont{\thu@font@name@xits@math}[
    Extension    = .otf,
    StylisticSet = \thu@xits@integral@stylistic@set,
  ]%
  \setmathfont{\thu@font@name@xits@math}[
    Extension    = .otf,
    StylisticSet = 1,
    range        = {cal,bfcal},
  ]%
}

% Libertinus Math
\newcommand\thu@libertinus@integral@stylistic@set{%
  \ifthu@integral@slanted
    8%
  \fi
}
\newcommand\thu@set@math@font@libertinus{%
  \thu@set@libertinus@names
  \setmathfont{\thu@font@name@libertinus@math}[
    Extension    = .otf,
    StylisticSet = \thu@libertinus@integral@stylistic@set,
  ]%
}

% New Computer Modern Math
\newcommand\thu@newcm@integral@stylistic@set{%
  \ifthu@integral@upright
    2%
  \fi
}
\newcommand\thu@set@math@font@newcm{%
  \setmathfont{NewCMMath-Book}[
    Extension    = .otf,
    StylisticSet = \thu@newcm@integral@stylistic@set,
  ]%
  \setmathfont{NewCMMath-Book}[
    Extension    = .otf,
    StylisticSet = 1,
    range        = {scr,bfscr},
  ]%
  \setmathrm{NewCM10}[
    Extension      = .otf,
    UprightFont    = *-Book,
    BoldFont       = *-Bold,
    ItalicFont     = *-BookItalic,
    BoldItalicFont = *-BoldItalic,
  ]%
  \setmathsf{NewCMSans10}[
    Extension         = .otf,
    UprightFont       = *-Book,
    BoldFont          = *-Bold,
    ItalicFont        = *-BookOblique,
    BoldItalicFont    = *-BoldOblique,
  ]%
  \setmathtt{NewCMMono10}[
    Extension           = .otf,
    UprightFont         = *-Book,
    ItalicFont          = *-BookItalic,
    BoldFont            = *-Bold,
    BoldItalicFont      = *-BoldOblique,
  ]%
}

% Latin Modern Math
\newcommand\thu@set@math@font@lm{%
  \setmathfont{latinmodern-math}[Extension=.otf]%
  \setmathrm{lmroman10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
  ]%
  \setmathsf{lmsans10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
  ]%
  \setmathtt{lmmonolt10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
  ]%
}

% NewTX Math
\newcommand\thu@set@math@font@newtx{%
  \ifthu@font@newtx\else
    \let\thu@save@encodingdefault\encodingdefault
    \let\thu@save@rmdefault\rmdefault
    \let\thu@save@sfdefault\sfdefault
    \let\thu@save@ttdefault\ttdefault
    \RequirePackage[T1]{fontenc}%
    \renewcommand{\rmdefault}{ntxtlf}%
    \renewcommand{\sfdefault}{qhv}%
    \renewcommand{\ttdefault}{ntxtt}%
  \fi
  \ifthu@uppercase@greek@italic
    \PassOptionsToPackage{slantedGreek}{newtxmath}%
  \fi
  \ifthu@integral@upright
    \PassOptionsToPackage{upint}{newtxmath}%
  \fi
  \RequirePackage{newtxmath}
  \let\thu@save@leq\leq
  \let\thu@save@geq\geq
  \ifthu@leq@slanted
    \let\le\leqslant
    \let\ge\geqslant
    \let\leq\leqslant
    \let\geq\geqslant
  \fi
  \ifthu@integral@limits@true
    \let\ilimits@\displaylimits
  \fi
  \let\thu@save@partial\partial
  \ifthu@partial@upright
    \let\partial\uppartial
  \fi
  \ifthu@math@ellipsis@centered
    \DeclareRobustCommand\mathellipsis{\mathinner{\cdotp\cdotp\cdotp}}%
  \else
    \DeclareRobustCommand\mathellipsis{\mathinner{\ldotp\ldotp\ldotp}}%
  \fi
  \let\thu@save@Re\Re
  \let\thu@save@Im\Im
  \ifthu@real@part@roman
    \def\Re{\operatorname{Re}}%
    \def\Im{\operatorname{Im}}%
  \fi
  \RequirePackage{bm}%
  \ifthu@font@newtx\else
    \let\encodingdefault\thu@save@encodingdefault
    \let\rmdefault\thu@save@rmdefault
    \let\sfdefault\thu@save@sfdefault
    \let\ttdefault\thu@save@ttdefault
  \fi
  \DeclareRobustCommand\symup[1]{{\mathrm{##1}}}%
  \DeclareRobustCommand\symbf[1]{{\bm{##1}}}%
  \let\increment\upDelta%
  \renewcommand\thu@qed{\openbox}%
}

% 设置数学字体
\newcommand\thu@set@math@font{%
  \ifthu@math@font@none\else
    \ifthu@math@font@newtx
      \thu@set@math@font@newtx
    \else
      \thu@load@unimath
      \thu@set@unimath@style
      \@nameuse{thu@set@math@font@\thu@math@font}%
    \fi
  \fi
}
\thu@option@hook{math-font}{\g@addto@macro\thu@setup@hook{\thu@set@math@font}}
\newcommand\thu@set@math@font@auto{%
  \ifthu@math@font@auto
    \thusetup{math-font=xits}%
  \fi
}
\AtBeginOfPackageFile*{siunitx}{\thu@set@math@font@auto}
\AtEndPreamble{\thu@set@math@font@auto}

%%%%%%%%%%%%%%%%%%%
% 主文档格式
%%%%%%%%%%%%%%%%%%%
% Three matters
% 定义\cleardoublepage命令，在openright情况下清除空白页页眉页脚
\def\cleardoublepage{
  \clearpage
  \if@twoside
    \ifthu@output@print
      \ifodd\c@page%\c@page是page的counter，此处判断是否为奇数
      \else
        %\thispagestyle{empty}% 修改：太原理工大学的模板不需要清空页眉页脚
        % 太原理工大学仅在正文开始，空白页添加页眉页脚
        \if@mainmatter
        	\relax
        \else
        	\thispagestyle{empty}
        \fi
       	\iftyut@covermatter% 修改：新增ifcovermatter
       		\thispagestyle{empty}
       	\fi
%       \iftyut@backmatter
%       	\thispagestyle{empty}
%       \fi
        \hbox{}%
        \newpage
        \if@twocolumn
          \hbox{}\newpage
        \fi
      \fi
    \fi
  \fi
}

% 重定义\frontmatter \mainmatter \backmatter，添加\cleardoublepage的功能
% 修改：新增ifbackmatter，新增iffrontmatter
\newif\iftyut@backmatter
\newif\iftyut@covermatter
\tyut@backmatterfalse
\tyut@covermatterfalse
\newcommand\covermatter{% 修改：新增covermatter
	\cleardoublepage
	\@mainmatterfalse
	\tyut@covermattertrue
}

\renewcommand\frontmatter{%
  \cleardoublepage
  \@mainmatterfalse
  \pagenumbering{Roman}%
  \tyut@covermatterfalse% 修改：判断封面（cover）部分是否结束
}
\renewcommand\mainmatter{%
  \cleardoublepage
  \@mainmattertrue
  \pagenumbering{arabic}%
}
\renewcommand\backmatter{%
  \if@openright
    \cleardoublepage
  \else
    \clearpage
  \fi
  \@mainmatterfalse
  \tyut@backmattertrue
  \thusetup{toc-depth = 0}%
}

%%%%%%%%%%%%%%%%%%%
% 页眉页脚
%%%%%%%%%%%%%%%%%%%
% fancy宏包有坑，详见实现细节中的描述。这里进行了修改保证无错。
\pagestyle{fancy}
% 页眉页脚字号，对齐方式。根据本科，研究生，博士生以及语言不同而规定相应样式。
\fancypagestyle{plain}{%
  \fancyhf{}%
  \renewcommand\footrulewidth{0pt}%
    \renewcommand\headrulewidth{0.75bp}%
    \fancyhead[CE]{%
    	\wuhao
    	太原理工大学硕士学位论文
    }
    \fancyhead[CO]{%
      \wuhao
      \ifthu@main@language@chinese
        \leftmark
      \else
        \MakeUppercase{\leftmark}%
      \fi
      }%
    \fancyfoot[C]{\wuhao\thepage}%
    \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markboth{%
        \CTEXifname{%
          \CTEXthechapter
          \ifthu@main@language@chinese
            \quad
          \else
            \space
          \fi
        }{}##1%
      }{}%
    }%
  \let\sectionmark\@gobble
}
\pagestyle{plain}
% 这里进行fancy“坑”的处理
\def\ps@chapter{}
\ctexset{chapter/pagestyle = chapter}

%%%%%%%%%%%%%%%%%%%%%%%
% 段落设置
%%%%%%%%%%%%%%%%%%%%%%%
\ctexset{%
  punct=quanjiao,
  space=auto,
}
\newcommand\thu@set@indent{%
  \ifthu@main@language@chinese
    \ctexset{autoindent=2}%
  \else
      \ctexset{autoindent=0.74cm}%
  \fi
}
\thu@set@indent
\thu@option@hook{degree}{\thu@set@indent}
\thu@option@hook{main-language}{\thu@set@indent}
% url的样式，与上下文一致
\urlstyle{same}
% xurl的方法，增加断行位置
\g@addto@macro\UrlBreaks{%
  \do0\do1\do2\do3\do4\do5\do6\do7\do8\do9%
  \do\A\do\B\do\C\do\D\do\E\do\F\do\G\do\H\do\I\do\J\do\K\do\L\do\M
  \do\N\do\O\do\P\do\Q\do\R\do\S\do\T\do\U\do\V\do\W\do\X\do\Y\do\Z
  \do\a\do\b\do\c\do\d\do\e\do\f\do\g\do\h\do\i\do\j\do\k\do\l\do\m
  \do\n\do\o\do\p\do\q\do\r\do\s\do\t\do\u\do\v\do\w\do\x\do\y\do\z
}
\Urlmuskip=0mu plus 0.1mu
% 取消列表间距（默认列表间距太宽了）
\partopsep=\z@skip
\def\@listi{\leftmargin\leftmargini
            \parsep \z@skip
            \topsep \z@skip
            \itemsep\z@skip}
\let\@listI\@listi
\@listi
\def\@listii {\leftmargin\leftmarginii
              \labelwidth\leftmarginii
              \advance\labelwidth-\labelsep
              \topsep    \z@skip
              \parsep    \z@skip
              \itemsep   \z@skip}
\def\@listiii{\leftmargin\leftmarginiii
              \labelwidth\leftmarginiii
              \advance\labelwidth-\labelsep
              \topsep    \z@skip
              \parsep    \z@skip
              \partopsep \z@skip
              \itemsep   \z@skip}
% enumitem命令调整默认列表环境间距
\setlist{nosep}

%%%%%%%%%%%%%%%%
% 脚注
%%%%%%%%%%%%%%%%
% 定义新的带圈数字脚注命令
\newcommand\thu@circled[1]{%
  \ifnum#1 >10\relax
    \thu@error{%
      Too many footnotes in this page.
      Keep footnote less than 10%
    }%
  \fi
  {\symbol{\the\numexpr#1+"245F\relax}}%
}
\renewcommand{\thefootnote}{\thu@circled{\c@footnote}}
\renewcommand{\thempfootnote}{\thu@circled{\c@mpfootnote}}
% 定义脚注分割线，字号（宋体小五），以及悬挂缩进（1.5字符）
\def\footnoterule{\vskip-3\p@\hrule\@width0.3\textwidth\@height0.4\p@\vskip2.6\p@}
\footnotemargin=13.5bp
% 修改footmisc定义的脚注格式。
\long\def\@makefntext#1{%
  \begingroup
    % 序号取消上标
    \def\@makefnmark{\hbox{\normalfont\@thefnmark}}%
    \xiaowu
    \ifFN@hangfoot
      \bgroup
      \setbox\@tempboxa\hbox{%
        \ifdim\footnotemargin>\z@
          \hb@xt@\footnotemargin{\@makefnmark\hss}%
        \else
          \@makefnmark
        \fi
      }%
      \leftmargin\wd\@tempboxa
      \rightmargin\z@
      \linewidth \columnwidth
      \advance \linewidth -\leftmargin
      \parshape \@ne \leftmargin \linewidth
      % \footnotesize
      \xiaowu
      \@setpar{{\@@par}}%
      \leavevmode
      \llap{\box\@tempboxa}%
      \parskip\hangfootparskip\relax
      \parindent\hangfootparindent\relax
    \else
      \parindent1em%
      \noindent
      \ifdim\footnotemargin>\z@
        \hb@xt@ \footnotemargin{\hss\@makefnmark}%
      \else
        \ifdim\footnotemargin=\z@
          \llap{\@makefnmark}%
        \else
          \llap{\hb@xt@ -\footnotemargin{\@makefnmark\hss}}%
        \fi
      \fi
    \fi
    \footnotelayout#1%
    \ifFN@hangfoot
      \par\egroup
    \fi
  \endgroup
}

% 允许公式断行、分页
\allowdisplaybreaks[4]
% 公式距前后文的距离由4个参数控制，参见\normalsize的定义。

%%%%%%%%%%%%%%%%%%%
% 浮动对象：表格和插图，图表设置
%%%%%%%%%%%%%%%%%%%
% 默认为位置h
\def\fps@figure{h}
\def\fps@table{h}
% 设置浮动对象和文字之间的距离
\setlength{\floatsep}{12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength{\textfloatsep}{12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength{\intextsep}{12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength{\@fptop}{0bp \@plus1.0fil}
\setlength{\@fpsep}{12bp \@plus2.0fil}
\setlength{\@fpbot}{0bp \@plus1.0fil}

\patchcmd{\@addtocurcol}%
{\vskip \intextsep}%
{\edef\save@first@penalty{\the\lastpenalty}\unpenalty
	\ifnum \lastpenalty = \@M  % hopefully the OR penalty
	\unpenalty
	\else
	\penalty \save@first@penalty \relax % put it back
	\fi
	\ifnum\outputpenalty <-\@Mii
	\addvspace\intextsep
	\vskip\parskip
	\else
	\addvspace\intextsep
	\fi}%
{}{\thu@patch@error{\@addtocurcol}}
\patchcmd{\@addtocurcol}%
{\vskip\intextsep \ifnum\outputpenalty <-\@Mii \vskip -\parskip\fi}%
{\ifnum\outputpenalty <-\@Mii
	\aftergroup\vskip\aftergroup\intextsep
	\aftergroup\nointerlineskip
	\else
	\vskip\intextsep
	\fi}%
{}{\thu@patch@error{\@addtocurcol}}
\patchcmd{\@getpen}{\@M}{\@Mi}
{}{\thu@patch@error{\@getpen}}
% 下面这组命令使浮动对象的缺省值稍微宽松一点，从而防止浮动对象占据过多的文本页面，也可以防止在很大空白的浮动页上放置很小的图形。
\renewcommand{\textfraction}{0.15}
\renewcommand{\topfraction}{0.85}
\renewcommand{\bottomfraction}{0.65}
\renewcommand{\floatpagefraction}{0.60}

% 允许用户设置图表编号的连接符，例如 1-2 或 1.2 
% 修改：太原理工大学要求连接符为“-”
\thu@define@key{
  figure-number-separator = {
    name    = figure@number@separator,
    default = {-},
  },
  table-number-separator = {
    name    = table@number@separator,
    default = {-},
  },
  equation-number-separator = {
    name    = equation@number@separator,
    default = {-},
  },
  algorithm-number-separator = {% 修改：添加算法分隔符定义
  	name    = algorithm@number@separator,
  	default = {-},
  },
  number-separator = {
    name    = number@separator,
    default = {-},
  },
}
\renewcommand\thefigure{%
  \ifnum\c@chapter>\z@
    \thechapter
    \thu@figure@number@separator
  \fi
  \@arabic\c@figure
}
\renewcommand\thetable{%
  \ifnum\c@chapter>\z@
    \thechapter
    \thu@table@number@separator
  \fi
  \@arabic\c@table
}
\renewcommand\theequation{%
  \ifnum\c@chapter>\z@
    \thechapter
    \thu@equation@number@separator
  \fi
  \@arabic\c@equation
}
%\renewcommand\thealgorithm{% 该部分移至\AtEndOfPackageFile*{algorithm}部分。
%	\ifnum\c@chapter>\z@
%	\thechapter
%	\thu@algorithm@number@separator
%	\fi
%	\@arabic\c@algorithm
%}
\newcommand\thu@set@number@separator{%
  \let\thu@figure@number@separator\thu@number@separator
  \let\thu@table@number@separator\thu@number@separator
  \let\thu@equation@number@separator\thu@number@separator
  \let\thu@algorithm@number@separator\thu@number@separator
}
\thu@option@hook{number-separator}{\thu@set@number@separator}

% 研究生要求表单元格中的文字采用11pt宋体字，单倍行距。段前空3磅，段后空3磅。段前段后的高度直接加到行距上，对于中文，修正后的行距为11 × 1.3 + 6 = 20.3(pt),而英文版的行距为11 × 1.3 + 6 = 18.65(pt)。用户可以手动设置\arraystretch调整表格的行距。
% 修改：太原理工大学要求，表中文字使用五号或小五号字体，单倍行距。五号字体为10.5bp=11.2pt
\newcommand\thu@set@table@font{
	\ifthu@language@chinese
	\def\thu@table@font{%
		\fontsize{10.5bp}{13.65bp}\selectfont
		\renewcommand\arraystretch{1}%
	}%
	\else
	\def\thu@table@font{%
		\fontsize{10.5bp}{12.6bp}\selectfont
		\renewcommand\arraystretch{1}%
	}%
	\fi
}
\thu@set@table@font
\thu@option@hook{language}{\thu@set@table@font}

%\AtBeginEnvironment{table}{%
%	\def\@floatboxreset{\reset@font\thu@table@font\@setminipage}%
%}
%\patchcmd{\@xfloat}{\normalsize}{\selectfont}{}{}

\patchcmd\@floatboxreset{% 将\@floatboxreset定义中的\normalsize换成其他字体大小
	\normalsize
}{%
	\thu@table@font
}{}{\thu@patch@error{\@floatboxreset}} % 注意：与宏包setspace冲突

% 对longtable跨页表格进行相同的设置
\AtEndOfPackageFile*{longtable}{
  \AtBeginEnvironment{longtable}{%
    \ifthu@language@chinese
      \fontsize{10.5bp}{13.65bp}\selectfont
    \else
      \fontsize{10.5bp}{12.6bp}\selectfont
    \fi
  }
}

% 定制浮动图形和表格标题样式，以及改变附录中浮动体的编号规则：图表标题字体为11pt；去掉图表号后面的冒号，图序与图名文字之间空一个汉字符宽度
% 图：caption在下，段前空6磅，段后空12磅
% 表：caption在上，段前空12磅，段后空6磅
% 修改：太原理工大学要求，图表标题字体中文为五号宋体,英文为五号 Times New Roman,单倍行距, 段前 6 磅,段后 6 磅。
\DeclareCaptionFont{thu}{%
    \wuhao\selectfont
}
\DeclareCaptionLabelFormat{tyutlabel}{#1 #2\hspace{1.5ex}} % 修改：自定义caption format
\captionsetup{
  font           = thu,
  labelformat	 = tyutlabel,
  labelsep       = none, % 一个space太难看，一个quad又太宽，所以自己定义了一个format
%  labelsep       = space, % 修改：太原理工大学要求表序与表题间隔一个字符
  aboveskip      = 6bp,
  belowskip      = 6bp,
  figureposition = bottom,
  tableposition  = top,
}
\captionsetup[sub]{font=thu}
\captionsetup[algorithm]{font=thu} % 修改：算法的caption为指定字体字号

%\renewcommand{\thesubfigure}{(\alph{subfigure})}
%\renewcommand{\thesubtable}{(\alph{subtable})} 修改：subcaption包被删去，此处报错

% 推荐使用三线表，并且要求表的上、下边线为单直线，线粗为1.5磅；第三条线为单直线，线粗为1磅。这里设置 booktabs 线粗的默认值
\heavyrulewidth=1.5bp
\lightrulewidth=1bp
\AtEndOfPackageFile*{threeparttable}{
  \g@addto@macro\TPT@defaults{\wuhao}
}

%%%%%%%%%%%%%%%%
% 章节标题
%%%%%%%%%%%%%%%%
\newcommand{\thu@abstract@name}{摘\quad 要}
% 太原理工硕士Abstract也全为大写
\newcommand{\thu@abstract@name@en}{ABSTRACT}

% 各级标题格式设置
\ctexset{%
  chapter = {
    nameformat   = {},
    numberformat = {},
    titleformat  = {},
    fixskip      = true,
    aftername    = \quad,
    afterindent  = true,
    lofskip      = 0pt,
    lotskip      = 0pt,
  },
  section = {
    aftername    = \quad,
    afterindent  = true,
  },
  subsection = {
    aftername    = \quad,
    afterindent  = true,
  },
  subsubsection = {
  	% 修改：子小节使用带括号的小标题
    aftername    = \quad,
    afterindent  = true,
    indent = 2em,
  },
  paragraph/afterindent = true,
  subparagraph/afterindent = true,
}
% 字号根据自己实际需要修改
% 各级别章节标题字号
\newcommand\thu@set@section@format{%
  % 研究生要求
  % 修改：太原理工大学
	%  章标题，三号黑体，单倍行距，段前 24 磅，段后 18 磅。
	%  一级节标题，四号黑体，单倍行距，段前 24 磅，段后 6 磅。
	%  二级节标题，小四号黑体，单倍行距，段前 12 磅，段后 6 磅。
    \ifthu@main@language@chinese
      \ctexset{%
        chapter = {
          format      = \centering\sffamily\sanhao,
          nameformat  = {},
          titleformat = {},
          name        = {第,章},
        },
        section = {
          format     = \sffamily\sihao\selectfont,
        },
        subsection = {
          format     = \sffamily\xiaosi\selectfont,
        },
        subsubsection = {
          format     = \sffamily\xiaosi\selectfont,
          number = \arabic{subsubsection}, % 修改：subsubsection使用(1)的形式编号
          name = {(,)},
        },
      }%
    \else
      \ctexset{%
        chapter = {
          format      = \centering\sffamily\bfseries\fontsize{16bp}{20bp}\selectfont,
          nameformat  = \MakeUppercase,
          titleformat = \MakeUppercase,
          name        = \chaptername\space,
        },
        section = {
          format     = \sffamily\bfseries\fontsize{14bp}{20bp}\selectfont,
        },
        subsection = {
          format     = \sffamily\bfseries\fontsize{13bp}{20bp}\selectfont,
        },
        subsubsection = {
          format     = \sffamily\bfseries\fontsize{12bp}{20bp}\selectfont,
        },
      }%
    \fi
    \ctexset{% 修改：太原理工大学章标题段前段后需要调整到以下
      chapter = {
        beforeskip = 27bp,
        afterskip  = 27bp,
        number     = \thechapter,
      },
      section = {
        beforeskip = 24bp,
        afterskip  = 6bp,
      },
      subsection = {
        beforeskip = 12bp,
        afterskip  = 6bp,
      },
      subsubsection = {
        beforeskip = 12bp,
        afterskip  = 6bp,
      },
    }%
}
\thu@set@section@format
\thu@option@hook{degree}{\thu@set@section@format}
\thu@option@hook{main-language}{\thu@set@section@format}
\newcommand\thu@english@number[1]{%
  \expandafter\ifcase\csname c@#1\endcsname
    Zero\or
    One\or
    Two\or
    Three\or
    Four\or
    Five\or
    Six\or
    Seven\or
    Eight\or
    Nine\or
    Ten\or
    Eleven\or
    Twelve\or
    Thirteen\or
    Fourteen\or
    Fifteen\or
    Sixteen\or
    Seventeen\or
    Eighteen\or
    Nineteen\or
    Twenty\or
    \thu@error{You are genius}%
  \fi
}

% 定义一个新的命令\thu@chapter* 来处理本科和研究生的章节格式
% 用法详见文档
\newcommand\thu@pdfbookmark[2]{}
\newcommand\thu@phantomsection{}
\NewDocumentCommand\thu@chapter{s o m o}{%
  \IfBooleanF{#1}{%
    \thu@error{You have to use the star form: \string\thu@chapter*}%
  }%
  \if@openright\cleardoublepage\else\clearpage\fi%
  \IfValueTF{#2}{%
    \ifthenelse{\equal{#2}{}}{%
      \thu@pdfbookmark{0}{#3}%
    }{%
      \thu@phantomsection
      \addcontentsline{toc}{chapter}{#2}%
    }%
  }{%
    \thu@phantomsection
    \addcontentsline{toc}{chapter}{#3}%
  }%
  \chapter*{#3}%
  \IfValueTF{#4}{%
    \ifthenelse{\equal{#4}{}}{%
      \@mkboth{}{}%
    }{%
      \@mkboth{#4}{#4}%
    }%
  }{%
    \@mkboth{#3}{#3}%
  }%
}

%%%%%%%%%%%%%%%%%%
% 目录
%%%%%%%%%%%%%%%%%
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}

% 重新定义\tableofcontents
\renewcommand\tableofcontents{%
  \thu@chapter*[]{\contentsname}% 修改：太原理工大学不需要目录出现在目录中
  \@starttoc{toc}%
}
\thu@define@key{
  toc-chapter-style = {
    name = toc@chapter@style,
    choices = {
      arial,
      times,
    },
    default = arial,
  },
}
\newcommand\thu@leaders{\titlerule*[4bp]{.}}
\newcommand\thu@set@toc@format{%
  \contentsmargin{\z@}%
  % 研究生要求
    \ifthu@main@language@chinese
      \titlecontents{chapter} % 修改：太原理工要求目录全用宋体小四号，前6后0，单倍行距
%        [\z@]{\addvspace{6bp}\sffamily}
        [\z@]{} % 修改：章级目录为宋体小四号，单倍行距。没有设置前6后0，但效果与模板一致
        {\contentspush{\thecontentslabel\enspace}}{} % 修改：将\quad改为\enspace
        {\rmfamily\thu@leaders\thecontentspage}%
      \titlecontents{section}
        [1em]{}
        {\contentspush{\thecontentslabel\enspace}}{}
        {\thu@leaders\thecontentspage}%
      \titlecontents{subsection}
        [2em]{}
        {\contentspush{\thecontentslabel\enspace}}{}
        {\thu@leaders\thecontentspage}%
    \else
      \titlecontents{chapter}
        [\z@]{\addvspace{6bp}\heiti}
        {\contentspush{\MakeUppercase{\thecontentslabel}\quad}\MakeUppercase}{\MakeUppercase}
        {\rmfamily\thu@leaders\thecontentspage}%
      \titlecontents{section}
        [1em]{}
        {\contentspush{\thecontentslabel\space}}{}  	name = {},
        number	 = {\arabic{subsubsection}},
        {\thu@leaders\thecontentspage}%
      \titlecontents{subsection}
        [2em]{}
        {\contentspush{\thecontentslabel\space}}{}
        {\thu@leaders\thecontentspage}%
    \fi
}
\thu@set@toc@format
\thu@option@hook{degree}{\thu@set@toc@format}
\thu@option@hook{main-language}{\thu@set@toc@format}

%%%%%%%%%%%%%%
% 封面和封底
%%%%%%%%%%%%%%
\thu@define@key{
  secret-level = {
    name = secret@level,
  },
  secret-year = {
    name = secret@year,
  },
  title = {
    default = {标题},
  },
  title* = {
    default = {Title},
    name    = title@en,
  },
  author = {
    default = {姓名},
  },
  author* = {
    default = {Name of author},
    name    = author@en,
  },
  degree-name = {
    default = {专业硕士},
    name    = degree@name,
  },
  degree-name* = {
    default = {Professional Master},
    name    = degree@name@en,
  },
  department = {
    default = {信息与计算机学院},
  },
  department* = { % 修改：太原理工大学要求封面使用学院英文名称，此处添加选项
  	name=department@en,
  },
  date = {
    default = {\the\year-\two@digits{\month}-\two@digits{\day}},
  },
  clc,
  udc,
  id,
  start-date = {
    name    = start@date,
    default = {\the\year-\two@digits{\month}-\two@digits{\day}},
  },
  end-date = {
    name    = end@date,
    default = {\the\year-\two@digits{\month}-\two@digits{\day}},
  },
}
\newcommand\thu@format@date[2]{%
  \edef\thu@@date{#2}%
  \def\thu@@process@date##1-##2-##3\@nil{%
    #1{##1}{##2}{##3}%
  }%
  \expandafter\thu@@process@date\thu@@date\@nil
}
\newcommand\thu@date@zh@digit[3]{#1 年 \number#2 月 \number#3 日}
\newcommand\thu@date@zh@digit@short[3]{#1 年 \two@digits{\number#2} 月}
\newcommand\thu@date@zh@short[3]{\zhdigits{#1}年\zhnumber{#2}月}
\newcommand\thu@date@month[1]{%
  \ifcase\number#1\or
    January\or February\or March\or April\or May\or June\or
    July\or August\or September\or October\or November\or December%
  \fi
}
\newcommand\thu@date@en@short[3]{\thu@date@month{#2} #1}
\newcommand\thu@underline[2][6em]{\hskip1pt\underline{\hb@xt@ #1{\hss#2\hss}}\hskip3pt}
\newcommand\thu@CJKunderline[2][6em]{\CJKunderline*{\hb@xt@ #1{\hss#2\hss}}}

% 三种box fixed stretch pad
\newcommand\thu@fixed@box[2]{%
  \begingroup
    \def\CJKglue{\hskip 0pt plus 2filll minus 1filll}%
    \makebox[#1][s]{#2}%
  \endgroup
}

\newbox\thu@stretch@box
\newcommand\thu@stretch[2]{%
  \sbox\thu@stretch@box{#2}% 将#2中的内容保存到\thu@stretch@box中
  \ifdim \wd\thu@stretch@box < #1\relax
    \begingroup
      \def\CJKglue{\hskip 0pt plus 2filll}%
      \makebox[#1][s]{#2}%
    \endgroup
  \else
    \box\thu@stretch@box
  \fi
}
\newbox\thu@pad@box
\newcommand\thu@pad[2]{%
  \sbox\thu@pad@box{#2}%
  \ifdim \wd\thu@pad@box < #1\relax% ifdim用来判断距离
    \makebox[#1][l]{\box\thu@pad@box}%
  \else
    \box\thu@pad@box
  \fi
}

\newcommand\thu@titlepage@secret{%
  \sffamily\sanhao
  \ifx\thu@secret@level\@empty
    \phantom{秘密}%
  \else
    \thu@secret@level★\makebox[3em][c]{\thu@secret@year}年%
  \fi\par
}

%%%%%%%%%%%%%%%%%%%
% 摘要设置
%%%%%%%%%%%%%%%%%%%
\thu@define@key{
  keywords,
  keywords* = {
    name = keywords@en,
  },
}

\newcommand\thu@clist@use[2]{%
  \def\thu@@tmp{}%
  \def\thu@clist@processor##1{%
    \ifx\thu@@tmp\@empty
      \def\thu@@tmp{#2}%
    \else
      #2%
    \fi
    ##1%
  }%
  \expandafter\comma@parse\expandafter{#1}{\thu@clist@processor}%
}

% 中文摘要格式
\newenvironment{abstract}{%
    \thusetup{language = chinese}%
    \begingroup % 使用begingroup\endgroup 可以改变此处的设置而不影响外部设置
      \ifthu@main@language@english
        \ctexset{% 这里的ctexset仅在begingroup\endgroup中有效
          chapter/format = \centering\rmfamily\fontsize{16bp}{20bp}\selectfont,
        }%
      \fi
      \thu@chapter*{\thu@abstract@name}%
    \endgroup
}{% 
  \par
  \null\par
  \noindent
  \textsf{关键词：}%
  \thu@clist@use{\thu@keywords}{；}%

  \thu@reset@main@language % switch back to main language
}

% 英文摘要格式
\newenvironment{abstract*}{%
  \thusetup{language = english}%
% 修改：英文摘要标题为三号 Times New Roman，居中，单倍行距，段前 24 磅，段后 18 磅；
%      \thu@chapter*{\thu@abstract@name@en}%
  \thu@chapter*{\rmfamily\thu@abstract@name@en}%
  \begingroup % 修改：太原理工大学，英文摘要需要缩进4个字符,但研究发现3.5ex正好
  \ctexset{autoindent=3.5ex}%
}{%
\endgroup
  \par
  \null\par
  \noindent
  \textbf{Keywords:}\space
  \thu@clist@use{\thu@keywords@en}{; }%
  \vspace*{\stretch{1}}%
  \thu@reset@main@language % switch back to main language
}

%%%%%%%%%%%%%%%%
% 符号对照表
%%%%%%%%%%%%%%%%
\newenvironment{denotation}[1][2.5cm]{%
  \thu@chapter*{\thu@denotation@name}%
  \vskip-30bp\xiaosi[1.6]\begin{thu@denotation}[labelwidth=#1] 
}{%
  \end{thu@denotation}
}
\newlist{thu@denotation}{description}{1}
\setlist[thu@denotation]{%
  nosep,
  font=\normalfont,
  align=left,
  leftmargin=!, % sum of the following 3 lengths
  labelindent=0pt,
  labelwidth=2.5cm,
  labelsep*=0.5cm,
  itemindent=0pt,
}

%%%%%%%%%%%%%%%%%
% 致谢和声明
%%%%%%%%%%%%%%%%%
\newcommand{\thu@statement@text}{本人郑重声明：所呈交的学位论文，是本人在导师指导下
  ，独立进行研究工作所取得的成果。尽我所知，除文中已经注明引用的内容外，本学位论
  文的研究成果不包含任何他人享有著作权的内容。对本论文所涉及的研究工作做出贡献的
  其他个人和集体，均已在文中以明确方式标明。}
\newcommand{\thu@signature}{签\hspace{1em}名：}
\newcommand{\thu@backdate}{日\hspace{1em}期：}
% 定义致谢与声明环境
\newenvironment{acknowledgements}{%
  \@mainmatterfalse
  \thu@chapter*{\thu@acknowledgements@name}%
}{%
}

% 声明部分（支持扫描文件替换）
\thu@define@key{
  statement-page-style = {
    name = statement@page@style,
    choices = {
      auto,
      empty,
      plain,
    },
    default = auto,
  },
  statement-page-number = {
    name = statement@page@number,
    choices = {
      false,
      true,
    },
    default = false,
  },
}
\thu@option@hook{statement-page-number}{%
  \ifthu@statement@page@number@false
    \thusetup{statement-page-style=empty}%
  \else
    \thusetup{statement-page-style=plain}%
  \fi
  \thu@warning{%
    The "statement-page-number" option is deprecated.
    Use "page-style" option of \protect\statement command instead%
  }%
}
\newcommand\statement[1][]{%
  \@mainmatterfalse
  \def\thu@statement@name{声\hspace{1em}明}%
  \let\thu@statement@file\@empty
  \kv@define@key{thu@statement}{page-style}{\thusetup{statement-page-style=##1}}%
  \kv@define@key{thu@statement}{file}{\let\thu@statement@file\kv@value}%
  \kv@set@family@handler{thu@statement}{%
    \ifx\kv@value\relax
      \let\thu@statement@file\kv@key
    \else
      \kv@handled@false
    \fi
  }%
  \kvsetkeys{thu@statement}{#1}%
  \ifthu@statement@page@style@auto
    \ifx\thu@statement@file\@empty
        \thusetup{statement-page-style = plain}%
    \else
        \thusetup{statement-page-style = empty}%
    \fi
  \fi
  \ifx\thu@statement@file\@empty
    \thusetup{language=chinese}%
      \begingroup
      \ifthu@main@language@english
        \ctexset{%
          chapter/format = \centering\sffamily\fontsize{16bp}{20bp}\selectfont,
        }%
      \fi
      \thu@chapter*{\thu@statement@name}%
    \endgroup
    \thispagestyle{\thu@statement@page@style}%
    \thu@statement@text\par
    \vskip 2cm%
    {\hfill\thu@signature\thu@underline[2.5cm]\relax
      \thu@backdate\thu@underline[2.5cm]\relax}%
    \thu@reset@main@language
  \else
    \includepdf[pagecommand={%
      \markboth{\thu@statement@name}{}%
      \thu@phantomsection
      \addcontentsline{toc}{chapter}{\thu@statement@name}%
      \thispagestyle{\thu@statement@page@style}%
    }]{\thu@statement@file}%
  \fi
}
\let\acknowledgement\acknowledgements
\let\endacknowledgement\endacknowledgements


%%%%%%%%%%%%%%%%%%%%%%%
% 插图清单和附表清单
%%%%%%%%%%%%%%%%%%%%%%%
\def\thu@listof#1{% #1: float type
  \setcounter{tocdepth}{2} % restore tocdepth in case being modified
  \@ifstar
    {\thu@chapter*[]{\csname list#1name\endcsname}\@starttoc{\csname ext@#1\endcsname}}
    {\thu@chapter*{\csname list#1name\endcsname}\@starttoc{\csname ext@#1\endcsname}}%
}
% 插图清单
\renewcommand\listoffigures{%
  \thu@listof{figure}%
}
\titlecontents{figure}
  [\z@]{}
  {\contentspush{\figurename~\thecontentslabel\quad}}{}
  {\nobreak\thu@leaders\nobreak\hfil\thecontentspage}

% 附表清单
\renewcommand\listoftables{%
  \thu@listof{table}%
}
\titlecontents{table}
  [\z@]{}
  {\contentspush{\tablename~\thecontentslabel\quad}}{}
  {\thu@leaders\thecontentspage}

% 将插图和附表合在一起列出“插图和附表清单”。% 使用bicaption会清单重复，可以添加list=off选项
\newcommand\listoffiguresandtables{%
  \thu@chapter*{\thu@list@figure@table@name}%
  \@starttoc{lof}% lof是list of figure的缩写
  \par
  \null\par
  \@starttoc{lot}% lot：list of table
}

% 公式列表
\def\ext@equation{loe}
\def\equcaption#1{%
  \addcontentsline{\ext@equation}{equation}%
                  {\protect\numberline{#1}}}
\newcommand\listofequations{\thu@listof{equation}}
\titlecontents{equation}
  [0pt]{\addvspace{6bp}}
  {\thu@equation@name~\thecontentslabel}{}
  {\nobreak\thu@leaders\nobreak\thecontentspage}

% 参考文献
\contentsuse{equation}{loe}
  \thu@define@key{
    cite-style = {
      name = cite@style,
      choices = {
        super,
        inline,
        author-year,
      }
    }
  }

% BibTeX +natbib宏包 具体见实现细节
\PassOptionsToPackage{compress}{natbib}
\AtEndOfPackageFile*{natbib}{
  \DeclareRobustCommand\inlinecite{\@inlinecite}
  \def\@inlinecite#1{\begingroup\let\@cite\NAT@citenum\citep{#1}\endgroup}
  \let\onlinecite\inlinecite
  \newcommand\bibstyle@super{%
    \bibpunct{[}{]}{,}{s}{,}{\textsuperscript{,}}}
  \newcommand\bibstyle@inline{%
    \bibpunct{[}{]}{,}{n}{,}{,}}
  \@namedef{bibstyle@author-year}{%
    \bibpunct{(}{)}{;}{a}{,}{,}}
  \thu@option@hook{cite-style}{\@nameuse{bibstyle@\thu@cite@style}}
  \@namedef{bibstyle@thuthesis-numeric}{\citestyle{super}}
  \@namedef{bibstyle@thuthesis-author-year}{\citestyle{author-year}}
  \@namedef{bibstyle@thuthesis-bachelor}{\citestyle{super}}
  \@namedef{bibstyle@thuthesis-inline}{\citestyle{inline}}
  \renewcommand\NAT@citesuper[3]{\ifNAT@swa
    \if*#2*\else#2\NAT@spacechar\fi
    % \unskip\kern\p@\textsuperscript{\NAT@@open#1\NAT@@close}%
    %  \if*#3*\else\NAT@spacechar#3\fi\else #1\fi\endgroup
    \unskip\kern\p@\textsuperscript{\NAT@@open#1\NAT@@close\if*#3*\else#3\fi}%
    \else #1\fi\endgroup}

  \renewcommand\NAT@citenum%
      [3]{\ifNAT@swa\NAT@@open\if*#2*\else#2\NAT@spacechar\fi
          % #1\if*#3*\else\NAT@cmt#3\fi\NAT@@close\else#1\fi\endgroup
          #1\NAT@@close\textsuperscript{\if*#3*\else#3\fi}\else#1\fi\endgroup}
      
  \def\NAT@citexnum[#1][#2]#3{%
    \NAT@reset@parser
    \NAT@sort@cites{#3}%
    \NAT@reset@citea
    \@cite{\def\NAT@num{-1}\let\NAT@last@yr\relax\let\NAT@nm\@empty
      \@for\@citeb:=\NAT@cite@list\do
      {\@safe@activestrue
      \edef\@citeb{\expandafter\@firstofone\@citeb\@empty}%
      \@safe@activesfalse
      \@ifundefined{b@\@citeb\@extra@b@citeb}{%
        {\reset@font\bfseries?}
          \NAT@citeundefined\PackageWarning{natbib}%
        {Citation `\@citeb' on page \thepage \space undefined}}%
      {\let\NAT@last@num\NAT@num\let\NAT@last@nm\NAT@nm
        \NAT@parse{\@citeb}%
        \ifNAT@longnames\@ifundefined{bv@\@citeb\@extra@b@citeb}{%
          \let\NAT@name=\NAT@all@names
          \global\@namedef{bv@\@citeb\@extra@b@citeb}{}}{}%
        \fi
        \ifNAT@full\let\NAT@nm\NAT@all@names\else
          \let\NAT@nm\NAT@name\fi
        \ifNAT@swa
        \@ifnum{\NAT@ctype>\@ne}{%
          \@citea
          \NAT@hyper@{\@ifnum{\NAT@ctype=\tw@}{\NAT@test{\NAT@ctype}}{\NAT@alias}}%
        }{%
          \@ifnum{\NAT@cmprs>\z@}{%
          \NAT@ifcat@num\NAT@num
            {\let\NAT@nm=\NAT@num}%
            {\def\NAT@nm{-2}}%
          \NAT@ifcat@num\NAT@last@num
            {\@tempcnta=\NAT@last@num\relax}%
            {\@tempcnta\m@ne}%
          \@ifnum{\NAT@nm=\@tempcnta}{%
            \@ifnum{\NAT@merge>\@ne}{}{\NAT@last@yr@mbox}%
          }{%
            \advance\@tempcnta by\@ne
            \@ifnum{\NAT@nm=\@tempcnta}{%
              % \ifx\NAT@last@yr\relax
              %   \def@NAT@last@yr{\@citea}%
              % \else
              %   \def@NAT@last@yr{--\NAT@penalty}%
              % \fi
              \def@NAT@last@yr{-\NAT@penalty}%
            }{%
              \NAT@last@yr@mbox
            }%
          }%
          }{%
          \@tempswatrue
          \@ifnum{\NAT@merge>\@ne}{\@ifnum{\NAT@last@num=\NAT@num\relax}{\@tempswafalse}{}}{}%
          \if@tempswa\NAT@citea@mbox\fi
          }%
        }%
        \NAT@def@citea
        \else
          \ifcase\NAT@ctype
            \ifx\NAT@last@nm\NAT@nm \NAT@yrsep\NAT@penalty\NAT@space\else
              \@citea \NAT@test{\@ne}\NAT@spacechar\NAT@mbox{\NAT@super@kern\NAT@@open}%
            \fi
            \if*#1*\else#1\NAT@spacechar\fi
            \NAT@mbox{\NAT@hyper@{{\citenumfont{\NAT@num}}}}%
            \NAT@def@citea@box
          \or
            \NAT@hyper@citea@space{\NAT@test{\NAT@ctype}}%
          \or
            \NAT@hyper@citea@space{\NAT@test{\NAT@ctype}}%
          \or
            \NAT@hyper@citea@space\NAT@alias
          \fi
        \fi
      }%
      }%
        \@ifnum{\NAT@cmprs>\z@}{\NAT@last@yr}{}%
        \ifNAT@swa\else
          % \@ifnum{\NAT@ctype=\z@}{%
          %   \if*#2*\else\NAT@cmt#2\fi
          % }{}%
          \NAT@mbox{\NAT@@close}%
          \@ifnum{\NAT@ctype=\z@}{%
            \if*#2*\else\textsuperscript{#2}\fi
          }{}%
        \fi
    }{#1}{#2}%
  }%
  \renewcommand\NAT@cite%
      [3]{\ifNAT@swa\NAT@@open\if*#2*\else#2\NAT@spacechar\fi
          % #1\if*#3*\else\NAT@cmt#3\fi\NAT@@close\else#1\fi\endgroup
          #1\NAT@@close\if*#3*\else\textsuperscript{#3}\fi\else#1\fi\endgroup}
  \def\NAT@citex%
    [#1][#2]#3{%
    \NAT@reset@parser
    \NAT@sort@cites{#3}%
    \NAT@reset@citea
    \@cite{\let\NAT@nm\@empty\let\NAT@year\@empty
      \@for\@citeb:=\NAT@cite@list\do
      {\@safe@activestrue
      \edef\@citeb{\expandafter\@firstofone\@citeb\@empty}%
      \@safe@activesfalse
      \@ifundefined{b@\@citeb\@extra@b@citeb}{\@citea%
        {\reset@font\bfseries ?}\NAT@citeundefined
                  \PackageWarning{natbib}%
        {Citation `\@citeb' on page \thepage \space undefined}\def\NAT@date{}}%
      {\let\NAT@last@nm=\NAT@nm\let\NAT@last@yr=\NAT@year
        \NAT@parse{\@citeb}%
        \ifNAT@longnames\@ifundefined{bv@\@citeb\@extra@b@citeb}{%
          \let\NAT@name=\NAT@all@names
          \global\@namedef{bv@\@citeb\@extra@b@citeb}{}}{}%
        \fi
      \ifNAT@full\let\NAT@nm\NAT@all@names\else
        \let\NAT@nm\NAT@name\fi
      \ifNAT@swa\ifcase\NAT@ctype
        \if\relax\NAT@date\relax
          \@citea\NAT@hyper@{\NAT@nmfmt{\NAT@nm}\NAT@date}%
        \else
          \ifx\NAT@last@nm\NAT@nm\NAT@yrsep
              \ifx\NAT@last@yr\NAT@year
                \def\NAT@temp{{?}}%
                \ifx\NAT@temp\NAT@exlab\PackageWarningNoLine{natbib}%
                {Multiple citation on page \thepage: same authors and
                year\MessageBreak without distinguishing extra
                letter,\MessageBreak appears as question mark}\fi
                \NAT@hyper@{\NAT@exlab}%
              \else\unskip\NAT@spacechar
                \NAT@hyper@{\NAT@date}%
              \fi
          \else
            \@citea\NAT@hyper@{%
              \NAT@nmfmt{\NAT@nm}%
              \hyper@natlinkbreak{%
                \NAT@aysep\NAT@spacechar}{\@citeb\@extra@b@citeb
              }%
              \NAT@date
            }%
          \fi
        \fi
      \or\@citea\NAT@hyper@{\NAT@nmfmt{\NAT@nm}}%
      \or\@citea\NAT@hyper@{\NAT@date}%
      \or\@citea\NAT@hyper@{\NAT@alias}%
      \fi \NAT@def@citea
      \else
        \ifcase\NAT@ctype
          \if\relax\NAT@date\relax
            \@citea\NAT@hyper@{\NAT@nmfmt{\NAT@nm}}%
          \else
          \ifx\NAT@last@nm\NAT@nm\NAT@yrsep
              \ifx\NAT@last@yr\NAT@year
                \def\NAT@temp{{?}}%
                \ifx\NAT@temp\NAT@exlab\PackageWarningNoLine{natbib}%
                {Multiple citation on page \thepage: same authors and
                year\MessageBreak without distinguishing extra
                letter,\MessageBreak appears as question mark}\fi
                \NAT@hyper@{\NAT@exlab}%
              \else
                \unskip\NAT@spacechar
                \NAT@hyper@{\NAT@date}%
              \fi
          \else
            \@citea\NAT@hyper@{%
              \NAT@nmfmt{\NAT@nm}%
              \hyper@natlinkbreak{\NAT@spacechar\NAT@@open\if*#1*\else#1\NAT@spacechar\fi}%
                {\@citeb\@extra@b@citeb}%
              \NAT@date
            }%
          \fi
          \fi
        \or\@citea\NAT@hyper@{\NAT@nmfmt{\NAT@nm}}%
        \or\@citea\NAT@hyper@{\NAT@date}%
        \or\@citea\NAT@hyper@{\NAT@alias}%
        \fi
        \if\relax\NAT@date\relax
          \NAT@def@citea
        \else
          \NAT@def@citea@close
        \fi
      \fi
      }}\ifNAT@swa\else
        % \if*#2*\else\NAT@cmt#2\fi
        \if\relax\NAT@date\relax\else\NAT@@close\fi
        \if*#2*\else\textsuperscript{#2}\fi
      \fi}{#1}{#2}}
  \renewcommand\bibsection{\thu@chapter*{\bibname}}
  \newcommand\thu@set@bibliography@format{%
      \renewcommand\bibfont{\fontsize{10.5bp}{16bp}\selectfont}%
      \setlength{\bibsep}{3bp \@plus 3bp \@minus 3bp}%
      \setlength{\bibhang}{21bp}%
  }
  \thu@set@bibliography@format
  \thu@option@hook{degree}{\thu@set@bibliography@format}
  \thu@option@hook{main-language}{\thu@set@bibliography@format}
  \patchcmd\thebibliography{%
    \clubpenalty4000%
  }{%
    \interlinepenalty=5000\relax
    \clubpenalty=10000\relax
  }{}{\thu@patch@error{\thebibliography}}
  \patchcmd\thebibliography{%
    \widowpenalty4000%
  }{%
    \widowpenalty=10000\relax
  }{}{\thu@patch@error{\thebibliography}}
% 参考文献表的编号居左,宽度 1 cm。
% 修改：太原理工大学模板中的宽度较小，此处取0.7
  \def\@biblabel#1{[#1]\hfill}
  \renewcommand\NAT@bibsetnum[1]{%
    % \settowidth\labelwidth{\@biblabel{#1}}%
    % \setlength{\leftmargin}{\labelwidth}%
    % \addtolength{\leftmargin}{\labelsep}%
    \setlength{\leftmargin}{1cm}%
    \setlength{\itemindent}{\z@}%
    \setlength{\labelsep}{0.1cm}%
    \setlength{\labelwidth}{0.7cm}%
    \setlength{\itemsep}{\bibsep}
    \setlength{\parsep}{\z@}%
    \ifNAT@openbib
      \addtolength{\leftmargin}{\bibindent}%
      \setlength{\itemindent}{-\bibindent}%
      \setlength{\listparindent}{\itemindent}%
      \setlength{\parsep}{0pt}%
    \fi
  }
}

% biblatex设置
\AtEndOfPackageFile*{biblatex}{
  \AtBeginDocument{
    \ifthenelse{\equal{\blx@bbxfile}{apa}}{\def\bibname{REFERENCES}}{}
    \ifthenelse{\equal{\blx@bbxfile}{apa6}}{\def\bibname{REFERENCES}}{}
    \ifthenelse{\equal{\blx@bbxfile}{mla}}{\def\bibname{WORKS CITED}}{}
    \ifthenelse{\equal{\blx@bbxfile}{mla-new}}{\def\bibname{WORKS CITED}}{}
  }
  \DeclareRobustCommand\inlinecite{\parencite}
  \defbibheading{bibliography}[\bibname]{\thu@chapter*{\bibname}}
  \newcommand\thu@set@bibliography@format{%
      \renewcommand\bibfont{\fontsize{10.5bp}{16bp}\selectfont}%
      \setlength{\bibitemsep}{3bp \@plus 3bp \@minus 3bp}%
      \setlength{\biblabelsep}{0.1cm}%
      \setlength{\bibhang}{21bp}%
  }
  \thu@set@bibliography@format
  \thu@option@hook{degree}{\thu@set@bibliography@format}
  \thu@option@hook{main-language}{\thu@set@bibliography@format}
}
\AtEndOfPackageFile*{apacite}{
  \AtBeginDocument{
    \thu@set@chapter@names
  }
  \renewcommand\bibliographytypesize{\fontsize{10.5bp}{17bp}\selectfont}
  \setlength{\bibitemsep}{6bp}
  \ifthu@main@language@chinese
    \setlength{\bibleftmargin}{21bp}
    \setlength{\bibindent}{-\bibleftmargin}
  \else
    \setlength{\bibleftmargin}{0.5in}
    \setlength{\bibindent}{-\bibleftmargin}
  \fi
  \def\st@rtbibchapter{%
    \if@numberedbib%
      \chapter{\bibname}%   e.g.,   6. References
    \else%
      \thu@chapter*{\bibname}%   e.g.,   References
    \fi%
  }%
}
\g@addto@macro\appendix{%
  \@mainmattertrue
}
\thu@define@key{
  toc-depth = {
    name = toc@depth,
  },
}
\thu@option@hook{toc-depth}{%
  \protected@write\@auxout{}{%
    \string\ttl@writefile{toc}{%
      \protect\setcounter{tocdepth}{\thu@toc@depth}%
    }%
  }%
  \addtocontents{lof}{\string\let\string\contentsline\string\ttl@gobblecontents}
  \addtocontents{lot}{\string\let\string\contentsline\string\ttl@gobblecontents}
  \addtocontents{loe}{\string\let\string\contentsline\string\ttl@gobblecontents}
}
\g@addto@macro\appendix{%
  \thusetup{
    toc-depth = 0,
  }%
}

\DeclareRobustCommand\thu@appendix@title[1]{\gdef\thu@appendix@@title{#1}}
\newcommand\thu@appendix@maketitle{%
  \par
  \begin{center}%
    \xiaosi[1.667]\thu@appendix@@title
  \end{center}%
  \par
}
\newcommand\thu@set@partial@toc@format{%
  \titlecontents{section}
    [\z@]{}
    {\contentspush{\thecontentslabel\quad}}{}
    {\thu@leaders\thecontentspage}%
  \titlecontents{subsection}
    [1em]{}
    {\contentspush{\thecontentslabel\quad}}{}
    {\thu@leaders\thecontentspage}%
  \titlecontents{subsubsection}
    [2em]{}
    {\contentspush{\thecontentslabel\quad}}{}
    {\thu@leaders\thecontentspage}%
}
\newcommand\thu@appendix@bibsection{%
  \par
  \vskip 20bp%
  \thu@pdfbookmark{1}{\bibname}%
  \begingroup
    \centering
    \xiaosi[1.667]\bibname\par
  \endgroup
  \vskip 6bp%
}%
\newcommand\thu@appendix@bibliography[1]{\putbib[#1]}

\newenvironment{resume}{% 简历及研究成果环境
  \@mainmatterfalse%
  \thu@chapter*{\thu@resume@name}%
  \ctexset{
    section = {
      format    += \centering,
      numbering = false,
    },
    subsection = {
      format     = \bfseries\fontsize{12bp}{20bp}\selectfont,
      numbering  = false,
      beforeskip = 1bp, % 修改：太原理工大学没有这么多间距
      afterskip  = 1bp,
%      aftertitle = \ifthu@language@chinese ：\else :\fi, % 修改：太原理工大学无需冒号
    },
  }%
}{}
\newcommand\resumeitem[1]{%
  \thu@error{The "\protect\resumeitem" is obsolete. Please update to the new format}%
}
\newcommand\researchitem[1]{%
  \thu@error{The "\protect\researchitem" is obsolete. Please update to the new format}%
}

\newlist{achievements}{enumerate}{1} %此处定义了新的列表环境
\setlist[achievements]{
  label      = [\arabic*],
  align      = left,
  leftmargin = 8mm, % leftmargin=labelsep+labelwidth
  topsep     = 0bp, % 修改：太原理工大学要求小四字体，行距20bp
  parsep     = 0bp,
  partopsep  = 0bp,
  itemsep    = 0bp,
  labelsep   = 3mm,
  labelwidth = 5mm,
  before     = {
  	\fontsize{12bp}{20bp}\selectfont % 修改：太原理工大学要求小四字体，行距20bp
  },
%  resume     = achievements,% 修改：太原理工大学要求独立编号
}

\newenvironment{publications}{%
  \thu@deprecate{"publications" environment}{"achievements"}%
  \begin{achievements}%
}{%
  \end{achievements}%
}

\newcommand\publicationskip{%
  \thu@error{The "\protect\publicationskip" is obsolete. Do not use it}%
}
\newenvironment{comments}[1][]{%
  \@mainmatterfalse
  \kv@define@key{thu@comments}{name}{\let\thu@comments@name\kv@value}%
  \kv@set@family@handler{thu@comments}{%
    \ifx\kv@value\relax
      \let\thu@comments@name\kv@key
    \else
      \kv@handled@false
    \fi
  }%
  \kvsetkeys{thu@comments}{#1}%
  \chapter{\thu@comments@name}%
}{%
}

\newenvironment{resolution}{%
  \@mainmatterfalse
  \chapter{\thu@resolution@name}%
}{}

\AtEndOfPackageFile*{hyperref}{
  \hypersetup{
    linktoc            = all,
    bookmarksdepth     = 2,
    bookmarksnumbered  = true,
    bookmarksopen      = true,
    bookmarksopenlevel = 1,
    bookmarksdepth     = 3,
    unicode            = true,
    psdextra           = true,
    breaklinks         = true,
    plainpages         = false,
    pdfdisplaydoctitle = true,
%    hidelinks,
  }%
  \newcounter{thu@bookmark}
  \renewcommand\thu@pdfbookmark[2]{%
    \phantomsection
    \stepcounter{thu@bookmark}%
    \pdfbookmark[#1]{#2}{thuchapter.\thethu@bookmark}%
  }
  \renewcommand\thu@phantomsection{%
    \phantomsection
  }
  \pdfstringdefDisableCommands{
    \let\\\relax
    \let\quad\relax
    \let\hspace\@gobble
  }%
  \@ifpackagelater{hyperref}{2019/04/27}{}{%
    \g@addto@macro\psdmapshortnames{\let\mu\textmu}
  }%
  \ifthu@main@language@chinese
    \hypersetup{
      pdflang = zh-CN,
    }%
  \else
    \hypersetup{
      pdflang = en-US,
    }%
  \fi
  \AtBeginDocument{%
    \ifthu@main@language@chinese
      \hypersetup{
        pdftitle    = \thu@title,
        pdfauthor   = \thu@author,
        pdfsubject  = \thu@degree@name,
        pdfkeywords = \thu@keywords,
      }%
    \else
      \hypersetup{
        pdftitle    = \thu@title@en,
        pdfauthor   = \thu@author@en,
        pdfsubject  = \thu@degree@name@en,
        pdfkeywords = \thu@keywords@en,
      }%
    \fi
    \hypersetup{
      pdfcreator={\thuthesis-v\version}}
  }%
}
\AtEndOfPackageFile*{nomencl}{
  \let\nomname\thu@denotation@name
  \def\thenomenclature{\begin{denotation}[\nom@tempdim]}
  \def\endthenomenclature{\end{denotation}}
}
\AtEndOfPackageFile*{siunitx}{%
  \sisetup{
    group-minimum-digits = 4,
    separate-uncertainty = true,
    inter-unit-product   = \ensuremath{{}\cdot{}},
  }
  \newcommand\thu@set@siunitx@language{%
    \ifthu@language@chinese
      \sisetup{
        list-final-separator = { 和 },
        list-pair-separator  = { 和 },
        range-phrase         = {～},
      }%
    \else
      \ifthu@language@english
        \sisetup{
          list-final-separator = {, and },
          list-pair-separator  = { and },
          range-phrase         = { to },
        }%
      \fi
    \fi
  }
  \thu@set@siunitx@language
  \thu@option@hook{language}{\thu@set@siunitx@language}
}
\AtEndOfPackageFile*{amsthm}{%
  \newtheoremstyle{thu}
    {\z@}{\z@}
    {\normalfont}{\z@}
    {\normalfont\sffamily}{\thu@theorem@separator}
    {0.5em}{}
  \theoremstyle{thu}
  \newtheorem{assumption}{\thu@assumption@name}[chapter]%
  \newtheorem{definition}{\thu@definition@name}[chapter]%
  \newtheorem{proposition}{\thu@proposition@name}[chapter]%
  \newtheorem{lemma}{\thu@lemma@name}[chapter]%
  \newtheorem{theorem}{\thu@theorem@name}[chapter]%
  \newtheorem{axiom}{\thu@axiom@name}[chapter]%
  \newtheorem{corollary}{\thu@corollary@name}[chapter]%
  \newtheorem{exercise}{\thu@exercise@name}[chapter]%
  \newtheorem{example}{\thu@example@name}[chapter]%
  \newtheorem{remark}{\thu@remark@name}[chapter]%
  \newtheorem{problem}{\thu@problem@name}[chapter]%
  \newtheorem{conjecture}{\thu@conjecture@name}[chapter]%
  \renewenvironment{proof}[1][\thu@proof@name]{\par
    \pushQED{\qed}%
    % \normalfont \topsep6\p@\@plus6\p@\relax
    \normalfont \topsep\z@\relax
    \trivlist
    \item[\hskip\labelsep
      %     \itshape
      % #1\@addpunct{.}]\ignorespaces
      \sffamily
      #1\@addpunct{\thu@theorem@separator}]\ignorespaces
  }{%
    \popQED\endtrivlist\@endpefalse
  }
  \renewcommand\qedsymbol{\thu@qed}
}
\AtEndOfPackageFile*{ntheorem}{%
  \theorembodyfont{\normalfont}%
  \theoremheaderfont{\normalfont\sffamily}%
  \theoremsymbol{\thu@qed}%
  \newtheorem*{proof}{\thu@proof@name}%
  \theoremstyle{plain}%
  \theoremsymbol{}%
  \theoremseparator{\thu@theorem@separator}%
  \newtheorem{assumption}{\thu@assumption@name}[chapter]%
  \newtheorem{definition}{\thu@definition@name}[chapter]%
  \newtheorem{proposition}{\thu@proposition@name}[chapter]%
  \newtheorem{lemma}{\thu@lemma@name}[chapter]%
  \newtheorem{theorem}{\thu@theorem@name}[chapter]%
  \newtheorem{axiom}{\thu@axiom@name}[chapter]%
  \newtheorem{corollary}{\thu@corollary@name}[chapter]%
  \newtheorem{exercise}{\thu@exercise@name}[chapter]%
  \newtheorem{example}{\thu@example@name}[chapter]%
  \newtheorem{remark}{\thu@remark@name}[chapter]%
  \newtheorem{problem}{\thu@problem@name}[chapter]%
  \newtheorem{conjecture}{\thu@conjecture@name}[chapter]%
}
\PassOptionsToPackage{chapter}{algorithm}
\AtEndOfPackageFile*{algorithm}{
  \floatname{algorithm}{\thu@algorithm@name}
  \renewcommand\thealgorithm{% 更改算法编号为【章节{separator}算法号】形式
  	\ifnum\c@chapter>\z@
  	\thechapter
  	\thu@algorithm@number@separator
  	\fi
  	\@arabic\c@algorithm
  }
  
  \renewcommand\listofalgorithms{%
    \thu@listof{algorithm}%
  }
  \renewcommand\listalgorithmname{\thu@list@algorithm@name}
  \def\ext@algorithm{loa}
  \contentsuse{algorithm}{loa}
  \titlecontents{algorithm}
    [\z@]{}
    {\contentspush{\fname@algorithm~\thecontentslabel\quad}}{}
    {\thu@leaders\thecontentspage}
}
\PassOptionsToPackage{algochapter}{algorithm2e}
\AtEndOfPackageFile*{algorithm2e}{
  \renewcommand\algorithmcfname{\thu@algorithm@name}
  \SetAlgoCaptionLayout{thu@caption@font}
  \SetAlCapSty{relax}
  \SetAlgoCaptionSeparator{\hspace*{1em}}
  \SetAlFnt{\fontsize{11bp}{14.3bp}\selectfont}
  \renewcommand\listofalgorithms{%
    \thu@listof{algorithmcf}%
  }
  \renewcommand\listalgorithmcfname{\thu@list@algorithm@name}
  \def\ext@algorithmcf{loa}
  \contentsuse{algocf}{loa}
  \titlecontents{algocf}
    [\z@]{}
    {\contentspush{\algorithmcfname~\thecontentslabel\quad}}{}
    {\thu@leaders\thecontentspage}
}
\AtEndOfPackageFile*{minted}{
  \newcommand\thu@set@listing@language{%
    \ifthu@language@chinese
      \floatname{listing}{代码}%
    \else
      \floatname{listing}{Listing}%
    \fi
  }
  \thu@set@listing@language
  \thu@option@hook{language}{\thu@set@listing@language}
}

\newcommand*\CJKmovesymbol[1]{\raise.3em\hbox{#1}}
\newcommand*\CJKmove{%
  \punctstyle{plain}%
  \let\CJKsymbol\CJKmovesymbol
  \let\CJKpunctsymbol\CJKsymbol
}

\DeclareRobustCommand\cs[1]{\texttt{\char`\\#1}}
\DeclareRobustCommand\file{\nolinkurl}
\DeclareRobustCommand\env{\textsf}
\DeclareRobustCommand\pkg{\textsf}
\DeclareRobustCommand\cls{\textsf}
\sloppy
\endinput
%%
%% End of file `thuthesis.cls'.
