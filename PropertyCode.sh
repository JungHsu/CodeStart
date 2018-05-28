#!/bin/bash
# author: JungHsu

echo "按下 <CTRL-D> 退出"

echo "请输入类名+对象名,格式为: 类名>对象名"
echo "🔈 多个参数以空格分割"

read P

# 字符串转换数组
OLD_IFS="$IFS" 
IFS=" " 
PARAMS=($P)
IFS="$OLD_IFS"  

# 模板
echo "正在读取模板..."
PROPERTY="@property (nonatomic, strong) @@CLASS@@   *@@OBJ@@;"
LAZY_METHOD="- (@@CLASS@@ *)@@OBJ@@{
    if (!_@@OBJ@@) {
        _@@OBJ@@ = [[@@CLASS@@ alloc]init];
    }
    return _@@OBJ@@;
}"

BUILD_CODE(){
	CLASS="$1"
	OBJ="$2"
	CONDITION="$3"

	if [[ $CONDITION == "PROPERTY" ]];
then

	PROPERTY_CODE=${PROPERTY//@@CLASS@@/$CLASS}
	PROPERTY_CODE=${PROPERTY_CODE//@@OBJ@@/$OBJ}
	echo "$PROPERTY_CODE"
else

	LAZY_CODE=${LAZY_METHOD//@@CLASS@@/$CLASS}
	LAZY_CODE=${LAZY_CODE//@@OBJ@@/$OBJ}	
	echo "$LAZY_CODE"
	echo ""
fi
}

# 处理每个参数的类和对象分割
HANDLE_PARAMS(){
	PARAM="$1"
	CONDITION="$2"

	CLASS=${PARAM%>*}
	OBJ=${PARAM##*>}
	
	BUILD_CODE "$CLASS" "$OBJ" "$CONDITION"
}



# 开始处理
echo "正常生成code..."

echo ""
echo "属性代码:"
for PARAM in ${PARAMS[@]}
do  
	HANDLE_PARAMS "$PARAM" "PROPERTY"
done

echo ""
echo "懒加载GET代码:"
for PARAM in ${PARAMS[@]}
do  
	HANDLE_PARAMS "$PARAM" "LAZY"
done


