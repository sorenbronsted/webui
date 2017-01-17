<?php

namespace ufds;

class Person extends DbObject implements RestEnable {
	private static $properties = [
		'uid'  => Property::INT,
		'name' => Property::STRING,
	];

	protected function getProperties() {
		return self::$properties;
	}
}