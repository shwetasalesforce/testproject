trigger RollupSummaryOnContactObject on Contact (after insert, after update, 
                                   after delete, after undelete) {
    set<Id> setId = new Set<Id>();
    List<Account> accList= new List<Account>();
    if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete){
        for(Contact con : trigger.new){         //AccountId
            setId.add(con.AccountId);
        }
    }
    if(trigger.isDelete || trigger.isUpdate){
        for(Contact con : trigger.old){
            setId.add(con.AccountId);
        }
    }
    List<Account> accountList= [ Select Id,No_of_Childs__c, 
                                 (Select AccountId from Contacts)
                                 From Account where Id = :setId ];
            for(Account accc : accountList){
            Integer Count = accc.Contacts.size();
            accc.No_of_Childs__c = count;
            accList.add(accc);
    }
    update accList;
}
