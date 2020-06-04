import NimQml
import eventemitter
import strformat
import strutils
import chronicles

import view
import views/asset_list
import views/account_list
import views/account_item
import ../../status/libstatus/wallet as status_wallet
import ../../signals/types

import ../../status/wallet
import ../../status/status

type WalletController* = ref object of SignalSubscriber
  status: Status
  view*: WalletView
  variant*: QVariant

proc newController*(status: Status): WalletController =
  result = WalletController()
  result.status = status
  result.view = newWalletView(status)
  result.variant = newQVariant(result.view)

proc delete*(self: WalletController) =
  delete self.view
  delete self.variant

proc init*(self: WalletController) =
  self.status.events.on("currencyChanged") do(e: Args):
    echo "currency changed"

  self.status.wallet.initAccounts()
  var accounts = self.status.wallet.accounts
  for account in accounts:
    self.view.addAccountToList(account)

method onSignal(self: WalletController, data: Signal) =
  debug "New signal received"
  discard
