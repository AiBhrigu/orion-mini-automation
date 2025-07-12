mod icrc1;
mod types;

use candid::candid_method;
use ic_cdk_macros::{query, update};

#[query(name = "icrc1_name")]
#[candid_method(query)]
fn name() -> String {
    icrc1::name()
}

#[query(name = "icrc1_symbol")]
#[candid_method(query)]
fn symbol() -> String {
    icrc1::symbol()
}

#[query(name = "icrc1_decimals")]
#[candid_method(query)]
fn decimals() -> u8 {
    icrc1::decimals()
}

#[query(name = "icrc1_total_supply")]
#[candid_method(query)]
fn total_supply() -> u64 {
    icrc1::total_supply()
}

#[query(name = "icrc1_balance_of")]
#[candid_method(query)]
fn balance_of(owner: candid::Principal) -> u64 {
    icrc1::balance_of(owner)
}

#[update(name = "icrc1_transfer")]
#[candid_method(update)]
fn transfer(to: candid::Principal, amount: u64) -> Result<(), String> {
    icrc1::transfer(to, amount)
}
