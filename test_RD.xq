declare namespace xsd="http://www.w3.org/2001/XMLSchema";

let $el0 := /xsd:schema/*
let $el1 := /xsd:schema/xsd:element
let $el2 := //*[@ref]

let $el3 := //xsd:element
let $el4 := //xsd:element[@name and not(@type)]/(xsd:complexType|xsd:simpleType)
let $el5 := //xsd:element[@name and (starts-with(@type,'xsd:')) and not(node())]

let $at1 := //xsd:attribute
let $at2 := //xsd:attribute[@name and not(@type)]/xsd:simpleType
let $at3 := //xsd:attribute[@name and (starts-with(@type,'xsd:')) and not(node())]

let $test1 := if(fn:count($el0)=1 and fn:count($el1)=1 and fn:count($el2)=0) then true() else false()
let $test2 := if(fn:count($el3)=fn:count($el4)+fn:count($el5)) then true() else false()
let $test3 := if(fn:count($at1)=fn:count($at2)+fn:count($at3)) then true() else false()

let $testRD := if ($test1 and $test2 and $test3) then "Yes" else "No" 

return <result>{ $testRD }</result>