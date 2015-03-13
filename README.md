# xml2txt
Little tool that converts xml to flatten text representation

For example:
~ $ cat test.xml 
<root>
    <node name="A">
        <value>5</value>
    </node>
    <othernode>X</othernode>
</root>
~ $ ruby xml2.rb test.xml 
root/node[name=A]/value=5
root/othernode=X

