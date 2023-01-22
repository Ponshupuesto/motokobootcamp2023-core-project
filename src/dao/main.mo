import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Hash "mo:base/Hash";
import List "mo:base/List";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Array "mo:base/Array";






actor {
    //My discord is: iri#1598
    //Feel free to DM me any question.

    stable var proposalsID = 0;
    stable var proposalEntries : [(Nat, Proposal)] = [];

    func natHash(n : Nat) : Hash.Hash { 
        Text.hash(Nat.toText(n));
    };

    let proposals = HashMap.fromIter<Nat, Proposal>(proposalEntries.vals(), Iter.size(proposalEntries.vals()), Nat.equal, natHash);


    





    type Proposal = {
        id : Nat;
        creator : Principal;
        votesYes : Nat;
        votesNo: Nat;
        voters : List.List<Principal>;
        payload : Text;
        time : Int;

    };// TO DEFINE;


    type Status ={
        #failed : Text;
        #open;
        #rejected;
        #accepted;

    };

    public type Subaccount = [Nat8];
    public type Account__1 = { owner : Principal; subaccount : ?Subaccount };
    public type Balance__1 = Nat;



    type Tokens={
        amount:Nat;
    };

    let MotokoToken : actor {icrc1_balance_of : shared query Account__1 -> async Balance__1;
    } = actor("db3eq-6iaaa-aaaah-abz6a-cai");

        /* public shared ({caller})func getMbBalance(id : Principal) : async Nat {
        let account1 : Account__1 = {owner = caller; subaccount = null};
        return await MotokoToken.icrc1_balance_of(account1);
  };  */


/*   public shared ({caller})func getMbBalance(id : Principal) : async Nat {
        let account1 : Account__1 = {owner = caller; subaccount = null};
        return await MotokoToken.icrc1_balance_of(account1);
  };  */

    public func getMbBalance(id:Principal) : async Nat {
        let account1 : Account__1 = {owner = id; subaccount = null};
        let total: Nat = await MotokoToken.icrc1_balance_of(account1);
        return total;
  }; 
  

    

    public shared({caller}) func submit_proposal(this_payload : Text) : async {#Ok : Proposal; #Err : Text} {


        let balance = await getMbBalance(caller);
        

        proposalsID += 1;
        var timeStamp = Time.now();

        let newProposal : Proposal ={
            id = proposalsID;
            creator = caller;
            votesYes = 0;
            votesNo = 0;
            voters = List.nil<Principal>();
            payload = this_payload;
            time = timeStamp;
        };

        proposals.put(newProposal.id,newProposal);

        return #Ok(newProposal);
        
    };

    public shared({caller}) func vote(proposal_id : Int, yes_or_no : Bool) : async {#Ok : (Nat, Nat); #Err : Text} {
        return #Err("Not implemented yet");
    };

    public query func get_proposal(id : Nat) : async ?Proposal {
        return proposals.get(id);
    };
    
    public query func get_all_proposals() : async [(Int, Proposal)] {
        Iter.toArray<(Int,Proposal)>(proposals.entries());
    };


    system func preupgrade() {
    proposalEntries := Iter.toArray<(Nat,Proposal)>(proposals.entries());
  };

  system func postupgrade() {
    proposalEntries := [];
  };


};