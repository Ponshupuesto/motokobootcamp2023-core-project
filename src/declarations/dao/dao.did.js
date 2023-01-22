export const idlFactory = ({ IDL }) => {
  const List = IDL.Rec();
  List.fill(IDL.Opt(IDL.Tuple(IDL.Principal, List)));
  const Proposal = IDL.Record({
    'id' : IDL.Nat,
    'creator' : IDL.Principal,
    'votesYes' : IDL.Nat,
    'time' : IDL.Int,
    'voters' : List,
    'votesNo' : IDL.Int,
    'payload' : IDL.Text,
  });
  return IDL.Service({
    'getMbBalance' : IDL.Func([IDL.Principal], [IDL.Nat], []),
    'get_all_proposals' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Int, Proposal))],
        ['query'],
      ),
    'get_proposal' : IDL.Func([IDL.Nat], [IDL.Opt(Proposal)], ['query']),
    'submit_proposal' : IDL.Func(
        [IDL.Text],
        [IDL.Variant({ 'Ok' : Proposal, 'Err' : IDL.Text })],
        [],
      ),
    'vote' : IDL.Func(
        [IDL.Int, IDL.Bool],
        [IDL.Variant({ 'Ok' : IDL.Tuple(IDL.Nat, IDL.Nat), 'Err' : IDL.Text })],
        [],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
