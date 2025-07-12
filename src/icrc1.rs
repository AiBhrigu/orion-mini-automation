use crate::types::*;
use candid::Principal;
use ic_cdk::api::caller;
use std::collections::HashMap;
use std::cell::RefCell;

thread_local! {
    static BALANCES: RefCell<HashMap<Principal, u64>> = RefCell::new(HashMap::new());
    static TOTAL_SUPPLY: RefCell<u64> = RefCell::new(0);
    static NAME: RefCell<String> = RefCell::new("BHRIGU Token".to_string());
    static SYMBOL: RefCell<String> = RefCell::new("BRI".to_string());
    static DECIMALS: RefCell<u8> = RefCell::new(8);
}

pub fn name() -> String {
    NAME.with(|n| n.borrow().clone())
}

pub fn symbol() -> String {
    SYMBOL.with(|s| s.borrow().clone())
}

pub fn decimals() -> u8 {
    DECIMALS.with(|d| *d.borrow())
}

pub fn total_supply() -> u64 {
    TOTAL_SUPPLY.with(|s| *s.borrow())
}

pub fn balance_of(owner: Principal) -> u64 {
    BALANCES.with(|b| *b.borrow().get(&owner).unwrap_or(&0))
}

pub fn transfer(to: Principal, amount: u64) -> Result<(), String> {
    let from = caller();

    BALANCES.with(|b| {
        let mut balances = b.borrow_mut();

        let from_balance = balances.get(&from).cloned().unwrap_or(0);
        if from_balance < amount {
            return Err("Insufficient balance".to_string());
        }

        *balances.entry(from).or_insert(0) -= amount;
        *balances.entry(to).or_insert(0) += amount;

        Ok(())
    })
}
