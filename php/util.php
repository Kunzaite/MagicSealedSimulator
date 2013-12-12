<?php

function merge($res, $in){
	if($in == null){
		return $res;
	} else {
		return array_merge($res, $in);
	}
}

function array_copy($arr) {
    $newArray = array();
    foreach($arr as $key => $value) {
        if(is_array($value)) $newArray[$key] = array_copy($value);
        elseif(is_object($value)) $newArray[$key] = clone $value;
        else $newArray[$key] = $value;
    }
    return $newArray;
}

?>