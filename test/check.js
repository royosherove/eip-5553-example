require('chai').should();
async function checkNum(contract,prop,expected){
    console.log('checking for number ' + expected + ' on ' + prop);
    const theProp = await contract[prop];
    const intermediate = await theProp();
    if (intermediate.toNumber){
        intermediate.toNumber().should.eq(expected);
        console.log('ok')
    }
    else {
        intermediate.should.eq(expected);
        console.log('ok (without toNumber)')
    }
}
async function checkStr(contract,prop,expected){
    console.log('checking for string ' + expected + ' on ' + prop);
    (await contract[prop]()).should.eq(expected);
    console.log('ok');
}
async function checkAddress(contract,prop,expected){
    console.log('checking for address ' + expected + ' on ' + prop);
    (await contract[prop]()).should.eq(expected);
    console.log('ok');
}
async function checkBool(contract,prop,expected){
    console.log('checking for address ' + expected + ' on ' + prop);
    (await contract[prop]()).should.eq(expected);
    console.log('ok');
}
async function checkBalance(contract,address,expected){
    console.log('checking balance for address ' + address );
    const result = await contract.balanceOf(address);
    console.log("was " + result);
    result.toString().should.eq(expected.toString());
    console.log('ok');
}
// async function checkPastEvents(contract,eventName,expctedValues){
//     console.log(`Checking for events of type ${eventName} in ${contract.name}`);
//     const keys = Object.keys(expctedValues);
//     const allEvents = await contract.getPastEvents(eventName,{fromBlock: 'earliest'});
//     const foundEvents =
//         allEvents.map(ev => {
//             const result = {issues:0, raw: ev.returnValues};
//             const loggedEventProps = Object.keys(ev.returnValues);
//             keys.forEach(fieldName => {
//                 const actual = ev.returnValues[fieldName];
//                 const expected = expctedValues[fieldName];
//                 if (actual !== expected) {
//                     result[fieldName] = {name: fieldName, expected, actual: actual | "undefined"};
//                     result.issues++;
//                 }
//             });
//             return result;
//         });
//     const matched = foundEvents.filter(ev => ev.issues === 0);
//     if (matched.length === 0) {
//         const msg = `${eventName} filter was not found in contract. all events:`;
//         foundEvents.forEach(ev => {
//             delete ev.raw[0];
//             delete ev.raw[1];
//             delete ev.raw[2];
//             delete ev.raw[3];
//             delete ev.raw[4];
//         });
//         const eventsMsg = JSON.stringify(foundEvents,null,2);
//         assert.fail(`${msg} ${eventsMsg}`)
//     }
//     return matched.map(match => match.raw);
// }
async function checkPastEvents(contract,eventName,expctedValues){
    console.log(`Checking for events of type ${eventName} in ${contract.name}`);
    const keys = Object.keys(expctedValues);
    const allEvents = await contract.getPastEvents(eventName,{fromBlock: 'earliest'});
    return allEvents;
}
// async function checkPastEvents(contract,eventName,predicate){
//     console.log(`Checking for events of type ${eventName} in ${contract.name}`);
//     const allEvents = await contract.getPastEvents(eventName,{fromBlock: 'earliest'});
//     const foundEvents =
//         allEvents
//             .map(ev => {
//                 return {result: predicate(ev.returnValues), item: ev}
//             })
//             .filter(output => (output.result === true))
//             .map(output => output.item);
//     if (foundEvents.length === 0) {
//         const msg = `${eventName} filter was not found in contract. all events:`;
//         const eventsMsg = JSON.stringify(allEvents.map(ev => ev.returnValues),null,2);
//         assert.fail(`${msg} ${eventsMsg}`)
//     }
//     return foundEvents;
// }

module.exports = {
    num: checkNum,
    str: checkStr,
    address: checkAddress,
    bool: checkBool,
    balance: checkBalance,
    events: checkPastEvents
};
