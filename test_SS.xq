declare namespace xsd="http://www.w3.org/2001/XMLSchema";

let $el0 := /xsd:schema/*

let $el1 := /xsd:schema/xsd:element[@name and not(@type)]/(xsd:complexType|xsd:simpleType)
let $el2 := /xsd:schema/xsd:element[@name and starts-with(@type,'xsd:') and not(node())]
let $el3 := $el0//xsd:element
let $el4 := $el0//xsd:element[not(@name) and @ref=/xsd:schema/xsd:element/@name]
let $el5 := /xsd:schema/xsd:element[@name=//xsd:element/@ref]

let $at1 := /xsd:schema/xsd:attribute[@name and not(@type)]/xsd:simpleType
let $at2 := /xsd:schema/xsd:attribute[@name and starts-with(@type,'xsd:') and not(node())]
let $at3 := $el0//xsd:attribute
let $at4 := $el0//xsd:attribute[not(@name) and @ref=/xsd:schema/xsd:attribute/@name]

let $test1 := if (fn:count($el0)=
                  fn:count($el1)+fn:count($el2)+fn:count($at1)+fn:count($at2)) then true() else false()
let $test2 := if (fn:count($el1)+fn:count($el2)=fn:count($el5)+1) then true() else false()
let $test3 := if (fn:count($el3)=fn:count($el4)) then true() else false()
let $test4 := if (fn:count($at3)=fn:count($at4)) then true() else false()

let $testSS := if ($test1 and $test2 and $test3 and $test4) then "Yes" else "No"

return <result>{ $testSS }</result>