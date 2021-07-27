# DOM Manipulation

Given a fetch() function that returns an Array of data where each element is an event Object containing the following keys/values:

```javascript
address_city: "Fort Worth"
address_state: "TX"
address_street_1: "500 Main Street"
address_street_2: "Suite 20"
address_zip: "75621"
contact_email: "bob@underwood.com"
contact_name: "Bob Underwood"
contact_phone: "817-555-9151"
cost: "$5"
description: "Come learn how to write a business plan"
end_time: "20200525T094419Z"
eventID: "001"
location_name: "Small Business Development Center"
office: "Dallas/Fort Worth"
recurring: false
registration_url: "https://smallbiztx.com/write-a-business-plan.html"
start_time: "20200525T094419Z"
title: "Business Plan Writing 101"
type: "in-person"
```

And an HTML table with rows structured as below (with every tr element containing a sequential data-row-id="#", as 1, 2, 3, etc.):

```html
<tr data-row-id="0">
    <th class="description" scope="row" role="rowheader">Description</th>
    <td class="address_city" data-sort-value="50">City</td>
    <td class="start_time" data-sort-value="331844400">Start Time</td>
    <td class="end_time" data-sort-value="327092400">End Time</td>
    <td class="type" data-sort-value="active">Type</td>
</tr>
```

## Magic Question
For the sake of balancing three developer constraints:

- Maintainability (ease of updating code to accommodate future business requirements)
- Readability (because your code is written once but read 5-10 times)
- Speed (because we have rapid deadlines and must be productive)

How do we take the provided data and hydrate the HTML in an effective way?

We ponder three solutions on this page and discuss each.

### Solution 1
```javascript
data.Items.forEach((event, index) => {
    const {
        description,
        address_city,
        start_time,
        end_time,
        type
    } = event;

    document.querySelector(`[data-row-id="${index}"] .description`).textContent = description;
    document.querySelector(`[data-row-id="${index}"] .address_city`).textContent = address_city;
    document.querySelector(`[data-row-id="${index}"] .start_time`).textContent = start_time;
    document.querySelector(`[data-row-id="${index}"] .end_time`).textContent = end_time;
    document.querySelector(`[data-row-id="${index}"] .type`).textContent = type;
})
```
#### Strengths
There's only one loop to reason around.  The loop is going over every event Object and then using the native DOM querySelector() to specifically fill in the data.  It's easy to see what exactly is happening.

#### Weaknesses
It's more verbose.  It requires more code to support any change.

### Solution 2
```javascript
const neededFields = ['description', 'address_city', 'start_time', 'end_time', 'type'];

data.Items.forEach((event, index) => {
    Object.keys(event).forEach((k) => {
        if (neededFields.includes(k)) {
            document.querySelector(`[data-row-id="${index}"] .${k}`).textContent = event[k];
        }
    })
})
```
#### Strengths
The use of a neededFields variable makes it easier to pull only the data you need.  You have less duplication of code across lines (fewer specific querySelector calls).  

#### Weaknesses
Two loops are more difficult to reason around, especially nested loops, and you have to maintain the neededFields array.

### Solution 3
```javascript
data.Items.forEach((event, index) => {
    const tdCollection = document.querySelector(`[data-row-id="${index}"]`).children;
    const tdArray = Array.from(tdCollection);

    tdArray.forEach((td) => {
        if (Object.keys(event).includes(td.className)) {
            td.textContent = event[td.className];
        }
    })
})
```
#### Strengths
This is the most scalable solution in that it can be re-used for all sorts of elements.  You can change your querySelector arbitrarily.  This code could be generalized to be less specific and work on any collection of DOM elements with children.

#### Weaknesses
It takes more brain power to understand the code.  This comes from having two loops and from inverting the processing method.  This method crawls across the DOM elements and fills them in, instead of going from data to DOM.

## Our Magic Answer
We believe Solution 1 is actually the most superior in its balancing of maintainability, readability, and speed.

We think it's most maintainabile (extensible), because if either the HTML structure or the data changes in the future, then it's easy for the developer to modify the code to accommodate.

We think its most readable because it only has a single loop and it follows a more imperative style of data flowing into DOM elements.

We think it's the fastest to develop, because it depends on native DOM methods and basic CSS queries.  It's logically easiest to reason around.

## Open Question
It feels like we're too tightly coupling data structure (and API response) to HTML structure and depending on future business requirements, this could be very problematic.  Is there a better way to do this that we haven't thought of yet?

Is this a problem we even need to worry about?