' BBType adds legacy Type functionality to BlitzMax Type

Type TBBType

	Field _list:TList
	Field _link:TLink

	Method Add(t:TList)
		_list=t
		_link=_list.AddLast(Self)
	End Method

	Method InsertBefore(t:TBBType)
		_link.Remove
		_link=_list.InsertBeforeLink(Self,t._link)
	End Method

	Method InsertAfter(t:TBBType)
		_link.Remove
		_link=_list.InsertAfterLink(Self,t._link)
	End Method

	Method Remove()
		_list.remove Self
	End Method

End Type

Function DeleteLast(t:TBBType)
	If t TBBType(t._list.Last()).Remove()
End Function

Function DeleteFirst(t:TBBType)
	If t TBBType(t._list.First()).Remove()
End Function

Function DeleteEach(t:TBBType)
	If t t._list.Clear()
End Function

Function ReadString$(in:TStream)
	Local	length
	length=ReadInt(in)
	If length>0 And length<1024*1024 Return brl.stream.ReadString(in,length)
End Function

Function HandleToObject:Object(obj:Object)
	Return obj
End Function

Function HandleFromObject(obj:Object)
	Local h=HandleToObject(obj)
	Return h
End Function


