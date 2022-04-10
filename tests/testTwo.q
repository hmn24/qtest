// Specify the different functions
.qtest.beforeRunTest:{};
.qtest.afterRunTest:{};

.qtest.runTest:{[]
  .qtest.firstTest[];
 };

.qtest.firstTest:{[]
  .qtest.assertEquals[1;2;"1 don't equal 2"];
  .qtest.assertGreaterThan[2;1;"2 greater than 1"];
  .qtest.assertGreaterThan[2;`;"2 greater than `"];
  .qtest.assertEquals[1;1;"1 equals 1"];
 };