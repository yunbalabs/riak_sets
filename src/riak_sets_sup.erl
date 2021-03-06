-module(riak_sets_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init(_Args) ->
    VMaster = { riak_sets_vnode_master,
                  {riak_core_vnode_master, start_link, [riak_sets_vnode]},
                  permanent, 5000, worker, [riak_core_vnode_master]},
    OpFSMs = {riak_sets_op_fsm_sup,
              {riak_sets_op_fsm_sup, start_link, []},
              permanent, infinity, supervisor, [riak_sets_op_fsm_sup]},

    { ok,
        { {one_for_one, 5, 10},
          [VMaster,OpFSMs]}}.
