.q.constructMsg:{[msg]
  :"<",(string .z.p),"> ",msg;
 };
.q.INFO:{[msg] -1 "[INFO] ",constructMsg msg};
.q.ERROR:{[msg] -2 "[ERROR] ",constructMsg msg; msg};
.q.FATAL:{[msg] -2 "[FATAL] ",constructMsg msg; 'msg};

.q.isString:{10h=type x};
.q.toString:{$[not type x;.z.s each x; 10h=abs type x;x; string x]};
.q.toSymbol:{$[11h=abs type x; x; `$toString x]};

.q.removeColons:{
    x:toString x;
    :(":"=first x) _ x;
 };

.q.exists:{"b"$ type key x};
.q.ensureFile:{hsym toSymbol x};
.q.setnx:{[name;val]
  if[-11h=type name; 'ERROR "Not a symbol: ",.Q.s1 name];
  :$[exists name; (::); name set val];
 };

.q.loadcode:{[file]
  system "l ",file:removeColons file;
  INFO "Loaded ",file," successfully";
 };