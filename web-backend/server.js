var http  = require('http');
var fs = require( 'fs' )
const mySecret = process.env['BLOG_PASSWORD']
http.createServer(async function(request,response){
    var requestPath = request.url;
    if(requestPath=="/"){
        requestPath="/index.html"
    }
    console.log("hey guys")
    console.log(requestPath)
    //async is hard i dont wanna use it
    var data = fs.readFileSync('../website'+requestPath, 'utf8');
    response.writeHead(200)
    response.end(data)
}).listen(80)