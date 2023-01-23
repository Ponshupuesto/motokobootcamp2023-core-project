import Text "mo:base/Text";

actor {
  
    stable var stable_text : Text = "";

    public type HeaderField = (Text,Text);
    public type HttpRequest = {
        body : Blob;
        headers: [HeaderField];
        method : Text;
        url : Text;
    };

    public type HttpResponse ={
        status_code : Nat16;
        headers : [HeaderField];
        body : Blob;
        
    };
    public query func http_request(request : HttpRequest) : async HttpResponse{
        let response = {
            body = Text.encodeUtf8(stable_text);
            headers = [("Content-Type", "text/html; charset=UTF-8")];
            status_code = 200 : Nat16;
            steraming_strategy = null;
        };

        return(response);
    };



    public func updateWebText (webText : Text) :  async (){
        stable_text := webText;
        return();
    };
};
