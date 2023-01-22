import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface Account {
  'owner' : Principal,
  'subaccount' : [] | [Subaccount],
}
export type List = [] | [[Principal, List]];
export interface Proposal {
  'status' : { 'Passed' : null } |
    { 'Open' : null } |
    { 'Rejected' : null },
  'creator' : Account,
  'votes' : [bigint, bigint],
  'voters' : List,
  'timestamp' : bigint,
  'payload' : string,
}
export type Subaccount = Uint8Array;
export interface _SERVICE {
  'getMbBalance' : ActorMethod<[Principal], bigint>,
  'get_all_proposals' : ActorMethod<[], Array<[bigint, Proposal]>>,
  'get_proposal' : ActorMethod<[bigint], [] | [Proposal]>,
  'submit_proposal' : ActorMethod<
    [string],
    { 'Ok' : Proposal } |
      { 'Err' : string }
  >,
  'vote' : ActorMethod<
    [bigint, boolean],
    { 'Ok' : [bigint, bigint] } |
      { 'Err' : string }
  >,
}
