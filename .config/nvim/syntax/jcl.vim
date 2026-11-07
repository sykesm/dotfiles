" Vim syntax file - IBM z/OS MVS JCL + JES2/JES3 JECL
" Rules: z/OS MVS JCL Reference SA23-1385-60, ch. 3 "Format of statements".
"
" Lookbehind cannot cross lines in syntax patterns, so state that spans cards is
" carried by `nextgroup=... skipnl` chains rather than multi-line patterns.
if exists('b:current_syntax') | finish | endif
syn case match
syn sync fromstart

let s:atom = '\%(\%<72v[^ '']\|''\%([^'']\|''''\)*''\)'
let s:Alt = {words -> '\%(' . join(words, '\|') . '\)'}

" --- statement chain: // -> name -> operation -> operands -> comment
syn match jclIdent  /^\/\/\ze[^* ]/ nextgroup=jclName,jclBadName
syn match jclIdent  /^\/\/\ze \+\S/ nextgroup=jclOperands,jclOperandsC,jclOp,jclIf,jclDDS,jclDDT skipwhite
syn match jclNull   /^\/\/ *$/
syn match jclBadName /[^ *]\S*/ contained nextgroup=jclOp,jclIf,jclDDS,jclDDT,jclBadOp skipwhite
syn match jclName    /[A-Z$#@][A-Z0-9$#@]\{0,7}\%(\.[A-Z$#@][A-Z0-9$#@]\{0,7}\)\?\%(\s\|$\)\@=/ contained nextgroup=jclOp,jclIf,jclDDS,jclDDT,jclBadOp skipwhite
syn match jclBadOp   /\S\+/ contained

syn cluster jclAtoms contains=jclString,jclKeyword,jclSymbol,jclTempDsn,jclReferback,jclGeneration,jclParen,jclComma,jclStar
" operand field: runs to the first blank outside apostrophes
exe 'syn match jclOperands /' . s:atom . '\+/ contained contains=@jclAtoms nextgroup=jclLongString,jclCommentMark,jclComment skipwhite'
" ... ending in comma-blank: a col 72 mark means nothing (IBM rule 6)
exe 'syn match jclOperandsC /' . s:atom . '*,\%(\s\|$\)\@=/ contained contains=@jclAtoms nextgroup=jclComment skipwhite'
syn match jclKeyword    /\<[A-Z][A-Z0-9#@$]*=\@=/ contained
syn match jclParen      /[()]/ contained
syn match jclComma      /,/ contained
syn match jclGeneration /([+-]\?\d\+)/ contained
syn match jclStar       /\*\%([,) ]\|$\)\@=/ contained
syn match jclReferback  /\*\.[A-Z$#@][A-Z0-9$#@.]*/ contained
syn match jclSymbol     /&[A-Z$#@][A-Z0-9$#@]*\.\?/ contained
syn match jclTempDsn    /&&[A-Z$#@][A-Z0-9$#@.]*/ contained
syn match jclString     /'\%([^']\|''\)*'/ contained contains=jclSymbol
" apostrophe value left open at end of card, continues at col 16 of the next
syn region jclLongString start=/\S\@1<='\%([^']\|''\)*$/ skip=/''/ end=/'/ contained contains=jclStringCont,jclSymbol nextgroup=jclOperandsTail,jclComment skipwhite
syn match jclStringCont /^\/\/ */ contained
exe 'syn match jclOperandsTail /\s\@1<!' . s:atom . '\+/ contained contains=@jclAtoms nextgroup=jclComment skipwhite'

" comments; a non-blank col 72 continues the comment on the next card
syn match jclComment     /\s\@1<=\%(\%<72v.\)\+/ contained contains=@Spell
syn match jclCommentMark /\s\@1<=\%(\%<72v.\)\+\%72v\@=/ contained contains=@Spell nextgroup=jclCol72Mark
syn match jclCol72Mark   /\S.*$/ contained contains=jclSeqArea nextgroup=jclCommentCont skipnl
syn match jclCommentCont /^\/\/ \%(\%<72v.\)*/ contained nextgroup=jclCol72Mark

" operation field; defined after jclOperands so it wins at the same column
let s:ops = [
      \ 'JOB', 'DD', 'PROC', 'OUTPUT', 'SET', 'JCLLIB', 'INCLUDE', 'CNTL',
      \ 'COMMAND', 'SCHEDULE', 'XMIT', 'EXPORT',
      \ 'JOBGROUP', 'GJOB', 'JOBSET', 'SJOB', 'AFTER', 'BEFORE', 'CONCURRENT',
      \ ]
let s:opsNoOperands = ['PEND', 'ELSE', 'ENDIF', 'ENDCNTL', 'ENDGROUP', 'ENDSET']
exe 'syn match jclOp /' . s:Alt(s:ops) . '\%(\s\|$\)\@=/ contained nextgroup=jclOperands,jclOperandsC skipwhite'
exe 'syn match jclOp /' . s:Alt(s:opsNoOperands) . '\%(\s\|$\)\@=/ contained nextgroup=jclComment skipwhite'
" IF: relational expression may contain blanks, and may span cards
syn region jclIf matchgroup=jclOp start=/IF\%(\s\|$\)\@=/ end=/\<THEN\>/ contained contains=jclIfWord,jclIfOperator,jclIfStep,jclParen,jclStringCont nextgroup=jclComment skipwhite
syn keyword jclIfWord RC ABEND ABENDCC RUN TRUE FALSE AND OR NOT EQ NE GT LT GE LE NG NL contained
syn match jclIfOperator /[&|¬<>=]\+/ contained
syn match jclIfStep /\<[A-Z$#@][A-Z0-9$#@]*\.\@=/ contained

" comment statements run through col 80; JES statements outrank them
syn match jclCommentStmt /^\/\/\*.*/ contains=@Spell
let s:jes3 = [
      \ 'DATASET', 'ENDDATASET', 'ENDPROCESS', 'FORMAT', 'MAIN', 'NET', 'NETACCT',
      \ 'OPERATOR', 'PAUSE', 'PROCESS', 'ROUTE', 'SIGNOFF', 'SIGNON',
      \ ]
let s:jes2 = [
      \ 'JOBPARM', 'MESSAGE', 'NETACCT', 'NOTIFY', 'OUTPUT', 'PRIORITY', 'ROUTE',
      \ 'SETUP', 'SIGNOFF', 'SIGNON', 'XEQ', 'XMIT',
      \ ]
exe 'syn match jclJes3 /^\/\/\*' . s:Alt(s:jes3) . '\>.*/'
" JES3 command statement: //** followed by the command verb
syn match jclJes3 /^\/\/\*\*[A-Z].*/
syn match jclDelim /^\/\*\%(\s.*\)\?$/
exe 'syn match jclJes2 /^\/\*' . s:Alt(s:jes2) . '\>.*/'
syn match jclJes2 /^\/\*\$.*/

" --- in-stream data. One chain per terminator rule (JCL Reference, DLM parm):
"   DD *            ends at /* or //
"   DD DATA         ends at /*
"   DD *,DLM=xx     ends at xx or //   (JES2; JES3 is xx only)
"   DD DATA,DLM=xx  ends at xx
" Each entry: [positional, end of data, start-of-data guard, end of DLM data]
let s:terms = {
      \ 'S': ['\*',   '^\%(\/\/\|\/\*\)\@=', '\%(^\/[/*]\)\@!', '^\z1\%(\s.*\)\?$\|^\%(\/\/\)\@='],
      \ 'T': ['DATA', '^\%(\/\*\)\@=',      '\%(^\/\*\)\@!',   '^\z1\%(\s.*\)\?$'],
      \ }
let s:noDlm = '\%(\%(DLM=\)\@!\%(\%<72v[^ ,'']\|''\%([^'']\|''''\)*''\)\+\)'
" lang names a utility control-statement language below; '' is plain data
function! s:DataChain(t, lang) abort
  let [head, endp, guard, dlmend] = s:terms[a:t]
  let k = a:t . a:lang
  let body = 'keepend contains=' . (a:lang ==# '' ? 'NONE' : '@jclLang' . a:lang)
  exe 'syn match jclDD' .k. ' /DD\ze\s\+' .head. '\%(\s\|,\|$\)/ contained nextgroup=jclHead' .k. ',jclHeadC' .k. ',jclHeadD' .k. ' skipwhite'
  " first card: positional then operands; three ways for the field to finish
  exe 'syn match jclHead'  .k. ' /' .head. '\%(,' .s:noDlm. '\)*\%(\s.*\)\?$/ contained contains=@jclAtoms,jclCmt' .k. ' nextgroup=jclData' .k. ' skipwhite skipnl skipempty'
  exe 'syn match jclHeadC' .k. ' /' .head. '\%(,' .s:noDlm. '\)*,\%(\s.*\)\?$/ contained contains=@jclAtoms,jclCmtC' .k. ' nextgroup=jclCard' .k. ' skipnl'
  exe 'syn match jclHeadD' .k. ' /' .head. '\%(,' .s:noDlm. '\)*,\%(DLM=\)\@=/ contained contains=@jclAtoms nextgroup=jclDlm' .k
  " continuation cards
  exe 'syn match jclCard'  .k. ' /^\/\/\ze \+\S/ contained nextgroup=jclOps' .k. ',jclOpsC' .k. ',jclOpsD' .k. ',jclDlm' .k. ' skipwhite'
  exe 'syn match jclOps'   .k. ' /' .s:noDlm. '\%(,' .s:noDlm. '\)*\%(\s.*\)\?$/ contained contains=@jclAtoms,jclCmt' .k. ' nextgroup=jclData' .k. ' skipwhite skipnl skipempty'
  exe 'syn match jclOpsC'  .k. ' /' .s:noDlm. '\%(,' .s:noDlm. '\)*,\%(\s.*\)\?$/ contained contains=@jclAtoms,jclCmtC' .k. ' nextgroup=jclCard' .k. ' skipnl'
  exe 'syn match jclOpsD'  .k. ' /' .s:noDlm. '\%(,' .s:noDlm. '\)*,\%(DLM=\)\@=/ contained contains=@jclAtoms nextgroup=jclDlm' .k
  " comments between the field and the data
  exe 'syn match jclCmt'   .k. ' /\s\+\S\%(\%<72v.\)*/ contained'
  exe 'syn match jclCmtC'  .k. ' /\s\+\S\%(\%<72v.\)*/ contained'
  exe 'syn region jclData' .k. ' start=/' .guard. '\S/ end=/' .endp. '/ contained ' . body
  " DLM: the capture has to live in the region start, so the region opens at DLM=
  exe 'syn region jclDlm' .k. " matchgroup=jclKeyword start=/DLM='\\?\\z([^', ]\\{2,18}\\)'\\?/ matchgroup=jclDelim end=/" .dlmend. '/ contained ' . body
  exe 'hi def link jclDD' .k. ' jclOp'
  for n in ['Cmt', 'CmtC'] | exe 'hi def link jcl' .n.k. ' jclComment' | endfor
  exe 'hi def link jclCard' .k. ' jclIdent'
  for n in ['Data', 'Dlm']
    exe 'hi def link jcl' .n.k. ' ' . (a:lang ==# '' ? 'jclData' : 'jclCtlData')
  endfor
endfunction
call s:DataChain('S', '')
call s:DataChain('T', '')

" --- utility control statements. Keyword-level only: commands, object words,
" KEYWORD( and KEYWORD= parameters, strings, comments, continuation marks.
"   cmds/objs: keyword tiers;  match: extra command patterns
"   cmt: C = /* */ (not in col 1, where /* ends the data),
"        Dash = --, Star = * in col 1;  cont: trailing - or +
let s:langs = {
      \ 'Idcams': {
      \   'cmds': ['ALLOCATE', 'ALTER', 'BLDINDEX', 'DCOLLECT', 'DEFINE', 'DEF', 'DELETE',
      \            'DEL', 'DIAGNOSE', 'EXAMINE', 'EXPORT', 'IMPORT', 'LISTCAT', 'LISTC',
      \            'LISTDATA', 'PRINT', 'REPRO', 'SETCACHE', 'SHCDS', 'VERIFY',
      \            'IF', 'THEN', 'ELSE', 'DO', 'END', 'SET', 'CANCEL', 'PARM'],
      \   'objs': ['ALIAS', 'ALTERNATEINDEX', 'AIX', 'CLUSTER', 'DATA', 'INDEX',
      \            'GENERATIONDATAGROUP', 'GDG', 'NONVSAM', 'PAGESPACE', 'PATH',
      \            'USERCATALOG', 'UCAT', 'MASTERCATALOG', 'LASTCC', 'MAXCC'],
      \   'cmt': ['C'], 'cont': 1},
      \ 'Iebcopy': {
      \   'cmds': ['COPY', 'COPYGRP', 'COPYGROUP', 'COPYMOD', 'ALTERMOD', 'SELECT', 'EXCLUDE']},
      \ 'Iebgener': {
      \   'cmds': ['GENERATE', 'EXITS', 'LABELS', 'MEMBER', 'RECORD']},
      \ 'Sort': {
      \   'cmds': ['ALTSEQ', 'DEBUG', 'END', 'INCLUDE', 'INREC', 'JOIN', 'JOINKEYS', 'MERGE',
      \            'MODS', 'OMIT', 'OPTION', 'OUTFIL', 'OUTREC', 'RECORD', 'REFORMAT',
      \            'SORT', 'SUM'],
      \   'cmt': ['Star']},
      \ 'Icetool': {
      \   'cmds': ['COPY', 'COUNT', 'DATASORT', 'DEFAULTS', 'DISPLAY', 'MODE', 'OCCUR',
      \            'RANGE', 'RESIZE', 'SELECT', 'SORT', 'SPLICE', 'STATS', 'SUBSET',
      \            'UNIQUE', 'VERIFY'],
      \   'cmt': ['Star'], 'cont': 1},
      \ 'Adrdssu': {
      \   'cmds': ['BUILDSA', 'COMPRESS', 'CONSOLIDATE', 'CONVERTV', 'COPY', 'COPYDUMP',
      \            'DEFRAG', 'DUMP', 'PRINT', 'RELEASE', 'RESTORE'],
      \   'objs': ['DATASET', 'DS', 'FULL', 'TRACKS'],
      \   'cmt': ['C'], 'cont': 1},
      \ 'Tso': {
      \   'cmds': ['ALLOCATE', 'ALLOC', 'ATTRIB', 'ATTR', 'CALL', 'CANCEL', 'DELETE', 'DEL',
      \            'EXEC', 'EX', 'FREE', 'HELP', 'ISPSTART', 'LISTALC', 'LISTA', 'LISTCAT',
      \            'LISTC', 'LISTDS', 'LISTD', 'OSHELL', 'OUTPUT', 'PRINTDS', 'PROFILE',
      \            'PROF', 'RECEIVE', 'RENAME', 'REN', 'SEND', 'SMCOPY', 'STATUS', 'SUBMIT',
      \            'SUB', 'TIME', 'TRANSMIT', 'XMIT',
      \            'DSN', 'RUN', 'BIND', 'REBIND', 'END', 'DCLGEN', 'ABEND'],
      \   'objs': ['PACKAGE', 'PLAN', 'TRIGGER'],
      \   'match': ['^\s*\zs[-%][A-Z][A-Z0-9#@$]*'],
      \   'extra': ['jclTsoProg'],
      \   'cmt': ['C'], 'cont': 1},
      \ 'Db2util': {
      \   'cmds': ['BACKUP', 'CATENFM', 'CATMAINT', 'CHECK', 'COPY', 'COPYTOCOPY', 'DIAGNOSE',
      \            'EXEC', 'ENDEXEC', 'LISTDEF', 'LOAD', 'MERGECOPY', 'MODIFY', 'OPTIONS',
      \            'QUIESCE', 'REBUILD', 'RECOVER', 'REORG', 'REPAIR', 'REPORT', 'RESTORE',
      \            'RUNSTATS', 'STOSPACE', 'TEMPLATE', 'UNLOAD'],
      \   'objs': ['DATA', 'DATABASE', 'INDEX', 'INDEXSPACE', 'INTO', 'LIST', 'PART',
      \            'RECOVERY', 'STATISTICS', 'SYSTEM', 'TABLE', 'TABLESPACE'],
      \   'cmt': ['Dash']},
      \ }

syn match  jclUParm    /\<[A-Z][A-Z0-9#@$]*[(=]\@=/ contained
syn match  jclUStr     /'\%([^']\|''\)*'/ contained
syn match  jclUCont    /[-+]\ze\s*\%($\|\%73v\)/ contained
syn region jclUCmtC    start=+\%>1v/\*+ end=+\*/+ contained
syn match  jclUCmtDash /--.*/ contained
syn match  jclUCmtStar /^\*.*/ contained
syn match  jclTsoProg  /\%(\<PROG\%(RAM\)\?(\)\@8<=[A-Z$#@][A-Z0-9$#@]*/ contained

let s:langGroups = []
for [s:lname, s:lang] in items(s:langs)
  let s:grp = 'jcl' . s:lname
  for [s:tier, s:suffix] in [['cmds', 'Cmd'], ['objs', 'Obj']]
    if has_key(s:lang, s:tier)
      exe 'syn keyword' s:grp . s:suffix 'contained' join(s:lang[s:tier])
    endif
  endfor
  for s:pat in get(s:lang, 'match', [])
    exe 'syn match' s:grp . 'Cmd /' . s:pat . '/ contained'
  endfor
  let s:items = [s:grp . 'Cmd', s:grp . 'Obj', 'jclUParm', 'jclUStr']
        \ + map(copy(get(s:lang, 'cmt', [])), '"jclUCmt" . v:val')
        \ + (get(s:lang, 'cont') ? ['jclUCont'] : []) + get(s:lang, 'extra', [])
  exe 'syn cluster jclLang' . s:lname . ' contains=' . join(s:items, ',')
  exe 'hi def link' s:grp . 'Cmd Statement'
  exe 'hi def link' s:grp . 'Obj Type'
  for s:t in ['S', 'T']
    call s:DataChain(s:t, s:lname)
    let s:langGroups += ['jclData' . s:t . s:lname, 'jclDlm' . s:t . s:lname]
  endfor
endfor
delfunction s:DataChain

" --- steps: which input DDs a program reads, and in which language. DD names
" are patterns. A step runs from its EXEC to the next EXEC, JOB, PROC or PEND.
let s:steps = [
      \ {'pgm': ['IDCAMS'], 'dd': {'SYSIN': 'Idcams'}},
      \ {'pgm': ['IEBCOPY'], 'dd': {'SYSIN': 'Iebcopy'}},
      \ {'pgm': ['IEBGENER', 'ICEGENER'], 'dd': {'SYSIN': 'Iebgener'}},
      \ {'pgm': ['SORT', 'ICEMAN'], 'dd': {'SYSIN': 'Sort', 'DFSPARM': 'Sort'}},
      \ {'pgm': ['ICETOOL'], 'dd': {'TOOLIN': 'Icetool', 'DFSPARM': 'Sort',
      \                             '[A-Z$#@][A-Z0-9$#@]\{3}CNTL': 'Sort'}},
      \ {'pgm': ['ADRDSSU'], 'dd': {'SYSIN': 'Adrdssu'}},
      \ {'pgm': ['IKJEFT01', 'IKJEFT1A', 'IKJEFT1B'], 'dd': {'SYSTSIN': 'Tso'}},
      \ {'pgm': ['DSNUTILB'], 'proc': ['DSNUPROC'], 'dd': {'SYSIN': 'Db2util'}},
      \ ]
" known programs without a control-statement language, for name highlighting
let s:utilities = [
      \ 'IEFBR14', 'IEBUPDTE', 'IEBCOMPR', 'IEHLIST', 'IEHPROGM', 'BPXBATCH',
      \ 'DSNTEP2', 'DSNTEP4', 'DSNTIAD', 'DSNTIAUL', 'DSN1COPY', 'DSN1PRNT', 'DSN1LOGP',
      \ 'DSNJU003', 'DSNJU004',
      \ ]

let s:name = '[A-Z$#@][A-Z0-9$#@]*'
let s:stepGroups = map(range(len(s:steps)), '"jclStep" . v:val')
for s:i in range(len(s:steps))
  let s:step = s:steps[s:i]
  let s:utilities += s:step.pgm + get(s:step, 'proc', [])
  let s:run = 'PGM=' . s:Alt(s:step.pgm)
  if has_key(s:step, 'proc')
    let s:run = '\%(' . s:run . '\|\%(PROC=\)\?' . s:Alt(s:step.proc) . '\)'
  endif
  exe 'syn region jclStep' . s:i . ' matchgroup=jclIdent'
        \ . ' start=/^\/\/\ze\%(' . s:name . '\)\? \+EXEC \+' . s:run . '\%([, ]\|$\)/'
        \ . ' end=/^\ze\/\/\%(' . s:name . '\)\? \+\%(EXEC\|JOB\|PROC\|PEND\)\%(\s\|$\)/'
        \ . ' contains=TOP,' . join(s:stepGroups, ',')
  let s:j = 0
  for [s:dd, s:lang] in items(s:step.dd)
    let s:id = s:i . '_' . s:j
    let s:ddname = '\%(' . s:name . '\.\)\?' . s:dd
    exe 'syn match jclStepDD' . s:id
          \ . ' /^\/\/\ze' . s:ddname . ' \+DD \+\%(\*\|DATA\)\%([ ,]\|$\)/'
          \ . ' contained containedin=jclStep' . s:i . ' nextgroup=jclStepDDName' . s:id
    exe 'syn match jclStepDDName' . s:id . ' /' . s:ddname . '/ contained'
          \ . ' nextgroup=jclDDS' . s:lang . ',jclDDT' . s:lang . ' skipwhite'
    exe 'hi def link jclStepDD' . s:id . ' jclIdent'
    exe 'hi def link jclStepDDName' . s:id . ' jclName'
    let s:j += 1
  endfor
endfor
" the region starts after //, so the step's own EXEC card restarts the chain
exe 'syn match jclStepName  /\%3c' . s:name . '/ contained containedin=' . join(s:stepGroups, ',') . ' nextgroup=jclOp skipwhite'
exe 'syn match jclStepBlank /\%3c \+\ze\S/ contained containedin=' . join(s:stepGroups, ',') . ' nextgroup=jclOp'

" EXEC: the program (PGM=name) or procedure (name, PROC=name) is always the
" first operand, so it is a link in the chain rather than a lookbehind atom
exe 'syn match jclOperandsNext /,' . s:atom . '*/ contained contains=@jclAtoms nextgroup=jclLongString,jclCommentMark,jclComment skipwhite'
exe 'syn match jclOperandsNextC /,\%(' . s:atom . '*,\)\?\%(\s\|$\)\@=/ contained contains=@jclAtoms nextgroup=jclComment skipwhite'
syn match jclExecGap /\s\+/ contained nextgroup=jclCommentMark,jclComment
let s:afterName = ' contained nextgroup=jclOperandsNext,jclOperandsNextC,jclExecGap'
exe 'syn match jclPgm /' . s:name . '/' . s:afterName
exe 'syn match jclProcRef /' . s:name . '\%([, ]\|$\)\@=/' . s:afterName
exe 'syn match jclUtility /' . s:Alt(uniq(sort(s:utilities))) . '\%([, ]\|$\)\@=/' . s:afterName
syn match jclExecPgm  /PGM=/  contained nextgroup=jclUtility,jclPgm,jclOperands,jclOperandsC
syn match jclExecProc /PROC=/ contained nextgroup=jclUtility,jclProcRef,jclOperands,jclOperandsC
syn match jclOp /EXEC\%(\s\|$\)\@=/ contained nextgroup=jclOperands,jclOperandsC,jclProcRef,jclUtility,jclExecPgm,jclExecProc skipwhite

" card layout: the col 72 mark only means something on statements; cols 73-80
" look the same on every line (data may use them, but they are usually
" sequence numbers there too)
let s:noCard = 'jclCommentStmt,jclJes2,jclJes3,jclDataS,jclDataT,jclDlmS,jclDlmT'
let s:ctl = join(s:langGroups + ['jclUCmtC', 'jclUCmtDash', 'jclUCmtStar'], ',')
exe 'syn match jclCol72   /\%72v\S/  containedin=ALLBUT,' . s:noCard . ',' . s:ctl . ',jclCol72Mark'
syn match jclSeqArea /\%>72v.*/ containedin=ALL

hi def link jclIdent Delimiter
hi def link jclName Identifier
hi def link jclBadName Error
hi def link jclBadOp Error
hi def link jclOp Statement
hi def link jclKeyword Type
hi def link jclSymbol PreProc
hi def link jclTempDsn Special
hi def link jclReferback Special
hi def link jclGeneration Number
hi def link jclParen Delimiter
hi def link jclComma Delimiter
hi def link jclStar Special
hi def link jclString String
hi def link jclLongString String
hi def link jclStringCont Delimiter
hi def link jclComment Comment
hi def link jclCommentMark Comment
hi def link jclCommentCont Comment
hi def link jclCommentStmt Comment
hi def link jclJes2 Macro
hi def link jclJes3 Macro
hi def link jclDelim Special
hi def link jclData String
hi def link jclIfWord Keyword
hi def link jclIfOperator Operator
hi def link jclIfStep Identifier
hi def link jclSeqArea LineNr
hi def link jclCol72 Todo
hi def link jclCol72Mark Todo
hi def link jclNull Delimiter
hi def link jclPgm Function
hi def link jclProcRef Function
hi def link jclUtility Constant
hi def link jclExecPgm jclKeyword
hi def link jclExecProc jclKeyword
hi def link jclStepName jclName
hi def link jclStepBlank jclIdent
hi def link jclCtlData Normal
hi def link jclUParm Function
hi def link jclUStr String
hi def link jclUCont Special
hi def link jclUCmtC Comment
hi def link jclUCmtDash Comment
hi def link jclUCmtStar Comment
hi def link jclTsoProg jclPgm
let b:current_syntax = 'jcl'
