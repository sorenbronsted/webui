<?php
namespace ufds;

class Person extends ModelObject {
	private static $properties = [
		'uid'  => Property::INT,
		'name' => Property::STRING,
		'address' => Property::STRING,
	];

	private static $mandatories = ['name', 'address'];

	protected function getProperties() {
		return self::$properties;
	}

	public function getMandatories() {
		return self::$mandatories;
	}
}