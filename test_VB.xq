declare namespace xsd="http://www.w3.org/2001/XMLSchema";

let $el0 := /xsd:schema/*

let $el1 := //xsd:element
let $el2 := //xsd:element[@name and 
                          (starts-with(@type,'xsd:') or @type=/xsd:schema/(xsd:complexType|xsd:simpleType)/@name)]
let $el3 := /xsd:schema/xsd:element
let $el4 := //*[@ref]

let $at1 := //xsd:attribute
let $at2 := //xsd:attribute[@name and 
                            (starts-with(@type,'xsd:') or @type=/xsd:schema/xsd:simpleType/@name)]

let $ct1 := /xsd:schema/xsd:complexType[@name=//xsd:element/@type]
let $ct2 := //xsd:complexType

let $st1 := /xsd:schema/xsd:simpleType[@name=//(xsd:element|xsd:attribute)/@type]
let $st2 := //xsd:simpleType

let $test1 := if(fn:count($el3)=1 and fn:count($el4)=0 and
                 fn:count($el0)=fn:count($ct1)+fn:count($st1)+1) then true() else false()
let $test2 := if(fn:count($el1)=fn:count($el2) and 
                 fn:count($at1)=fn:count($at2)) then true() else false()
let $test3 := if(fn:count($ct1)=fn:count($ct2) and 
                 fn:count($st1)=fn:count($st2)) then true() else false()

let $testVB := if ($test1 and $test2 and $test3) then "Yes" else "No"

return <result>{ $testVB }</result>