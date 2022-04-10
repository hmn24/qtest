// To load the corresponding arguments for qtest.q lib
.argparse.getCmdLineArgs:{
  :(" " sv) each .Q.opt[.z.x];
 };

.argparse.parseCmdLineArgs:{
  delete cmd from `.argparse;
  .argparse.cmd.:(::);
  .argparse.cmd,:.argparse.getCmdLineArgs[];
 };

.argparse.getArgs:{[name]
  :.argparse.cmd[toSymbol name];
 };

.argparse.castArgs:{[name;func]
  @[`.argparse.cmd;toSymbol name;func];
  INFO "Updated argparse <",(toString name),"> successfully";
 };

.argparse.resetAllArgs:{[]
  .argparse.cmd,:.argparse.getCmdLineArgs[];
 };

.argparse.resetOneArgs:{[name]
  name:toSymbol name;
  .argparse.cmd[name]:.argparse.getCmdLineArgs[][name];
 };
