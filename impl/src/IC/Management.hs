{-
Plumbing related to Candid and the management canister.
-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE QuasiQuotes #-}
{-# OPTIONS_GHC -Wno-orphans #-}
module IC.Management where

import Codec.Candid
import IC.Types
import qualified Data.ByteString.Lazy as BS

-- This needs cleaning up
principalToEntityId :: Principal -> EntityId
principalToEntityId = EntityId . BS.fromStrict . rawPrincipal

entityIdToPrincipal :: EntityId -> Principal
entityIdToPrincipal = Principal . BS.toStrict . rawEntityId

type InstallMode = [candidType|
    variant {install : null; reinstall : null; upgrade : null}
  |]

type ICManagement m =
  [candid|
    service ic : {
      create_canister : (record {
        desired_id : opt principal
      }) -> (record {canister_id : principal});
      install_code : (record {
        mode : variant {install : null; reinstall : null; upgrade : null};
        canister_id : principal;
        wasm_module : blob;
        arg : blob;
        compute_allocation : opt nat;
      }) -> ();
      set_controller : (record {
        canister_id : principal;
        new_controller : principal;
      }) -> ();
    }
  |]