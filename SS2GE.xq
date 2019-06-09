<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">

{ for $elc in /xsd:schema/xsd:element[xsd:complexType]
  let $ct := $elc/xsd:complexType/*
  let $type := concat($elc/@name,'Type')
  return
    <xsd:complexType name="{$type}">
      {$ct}
    </xsd:complexType>
}

{ for $elc in /xsd:schema/xsd:element[xsd:complexType]
  let $type := concat($elc/@name,'Type')
  return
    <xsd:element name="{$elc/@name}" type="{$type}"/>
}

{ for $eas in /xsd:schema/(xsd:element|xsd:attribute)[xsd:simpleType]
  let $st := $eas/xsd:simpleType/*
  let $type := concat($eas/@name,'Type')
  return
    <xsd:simpleType name="{$type}">
      {$st}
    </xsd:simpleType>
}

{ for $els in /xsd:schema/xsd:element[xsd:simpleType]
  let $type := concat($els/@name,'Type')
  return
    <xsd:element name="{$els/@name}" type="{$type}"/>
}

{ for $el in /xsd:schema/xsd:element[@type]
  return $el
}

{ for $at in /xsd:schema/xsd:attribute[@type]
  return $at
}

</xsd:schema>