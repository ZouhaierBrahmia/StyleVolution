declare namespace xsd="http://www.w3.org/2001/XMLSchema";

let $el0 := /xsd:schema/*
let $el1 := /xsd:schema/xsd:element[@name and 
                                    (starts-with(@type,'xsd:') or @type=/xsd:schema/(xsd:complexType|xsd:simpleType)/@name)]
let $el2 := $el1[@name=//xsd:element/@ref]
let $el3 := $el0//xsd:element
let $el4 := $el0//xsd:element[not(@name) and @ref=/xsd:schema/xsd:element/@name]

let $at1 := /xsd:schema/xsd:attribute[@name and (starts-with(@type,'xsd:') or @type=/xsd:schema/xsd:simpleType/@name)]
let $at2 := $el0//xsd:attribute
let $at3 := $el0//xsd:attribute[not(@name) and @ref=/xsd:schema/xsd:attribute/@name]

let $ct1 := /xsd:schema/xsd:complexType[@name=//xsd:element/@type]
let $ct2 := //xsd:complexType

let $st1 := /xsd:schema/xsd:simpleType[@name=//(xsd:element|xsd:attribute)/@type]
let $st2 := //xsd:simpleType

let $test1 := if (fn:count($el0)=
                  fn:count($el1)+fn:count($at1)+
                  fn:count($ct1)+fn:count($st1)) then true() else false()
let $test2 := if (fn:count($el1)=fn:count($el2)+1) then true() else false()
let $test3 := if (fn:count($el3)=fn:count($el4)) then true() else false()
let $test4 := if (fn:count($at2)=fn:count($at3)) then true() else false()
let $test5 := if (fn:count($ct1)=fn:count($ct2) and 
                  fn:count($st1)=fn:count($st2)) then true() else false()

let $testGE := if ($test1 and $test2 and $test3 and $test4 and $test5) then "Yes" else "No"

return <result>{ $testGE }</result>