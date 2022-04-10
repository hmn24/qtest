// Load argparse library
\l q.q
loadcode `:argparse.q;

// Determine argparse arguments and cast it with the types accordingly
.argparse.parseCmdLineArgs[];
.argparse.castArgs[`action;toSymbol];

// Determine which qtest file to run
.qtest.action:.argparse.getArgs[`action];
.qtest.file:.argparse.getArgs[`file];

// Initialise schema to store results of any tests
.qtest.result:([] file:`$(); lineNo:`long$(); status:`$(); name:`$(); result:; expected:; msg:);

// qtest functions to be overriden
.qtest.beforeRunTest:{};
.qtest.runTest:{};
.qtest.afterRunTest:{};

// Standard qtest functions to test
.qtest.getFunctionNameAndLineNumber:@[{[]
  bt:.Q.btx .Q.Ll[];
  bt:bt[;1];
  // For windows PC
  if[.z.o=`w64; bt[;1]:ssr[;"\\";"/"] each bt[;1]];
  bt@:where bt[;1] like "*",.qtest.file;
  bt@:where not bt[;0] like ".qtest.runTest";
  bt:first bt;
  :exec name:`$bt[0],
        lineNo:bt[2] from (`$())!();
 };;`name`lineNo!(`;0N)];

.qtest.assertThat:{[func;valA;valB;msg]
  res:.[func;(valA;valB);::];
  resStatus:$[res~1b;`pass;res~0b;`fail;`error];
  .qtest.result:.qtest.result uj enlist exec
    file:`$.qtest.file,
    lineNo,
    status:resStatus,
    name,
    result:res,
    expected:1b,
    msg:msg from .qtest.getFunctionNameAndLineNumber[];
 };

.qtest.assertEquals:{[valA;valB;msg]
  .qtest.assertThat[~;valA;valB;msg];
 };

.qtest.assertGreaterThan:{[valA;valB;msg]
  .qtest.assertThat[>;valA;valB;msg];
 };

.qtest.assertGreaterAndEqualsThan:{[valA;valB;msg]
  .qtest.assertThat[>=;valA;valB;msg];
 };

.qtest.assertLesserThan:{[valA;valB;msg]
  .qtest.assertThat[<;valA;valB;msg];
 };

.qtest.assertLesserAndEqualsThan:{[valA;valB;msg]
  .qtest.assertThat[<=;valA;valB;msg];
 };

// Ensure .qtest.file is specified
if[.qtest.action=`runTest;
  $[(.qtest.file~"") or (not exists ensureFile .qtest.file) or (0=count .qtest.file);
    @[FATAL;"No .qtest.file specified!";{exit 1}];
    loadcode .qtest.file
  ];
 ];

// Perform the corresponding actions
if[.qtest.action=`cleanResult; 
  @[hdel;`:qtest.log;::];
 ];
if[.qtest.action=`showResult;
  system "c 2000 2000";
  INFO each "\n" vs .Q.s @[{select from x where status<>`pass} get ::;`:qtest.log;::];
 ];
if[.qtest.action=`runTest;
  INFO "Initialising qtest for ",.qtest.file;
  if[exists `:qtest.log; .qtest.result,:get `:qtest.log];
  .qtest.beforeRunTest[];
  .qtest.runTest[];
  .qtest.afterRunTest[];
  `:qtest.log set .qtest.result;
  INFO "Succesfully ran qtest for ",.qtest.file;
 ];

exit 0;


