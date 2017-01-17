<?php
namespace ufds;

use PHPUnit_Framework_TestCase;

require_once 'web/settings.php';

class PersonTest extends PHPUnit_Framework_TestCase {
	protected function setUp() {
		Db::exec(Person::$db, 'delete from person');
	}

	public function testOne() {
		$p = new Person();
		$p->name = 'Kurt Humbuk';
		$p->save();

		$persons = Person::getAll();
		$this->assertEquals(1, count($persons));
	}
}
