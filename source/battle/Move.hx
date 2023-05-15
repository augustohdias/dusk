package battle;

class Move {
    public var name:String;
	public var power:Int;
	public var type:Type;

	private function new(name:String, power:Int, type:Type) {
		this.name = name;
        this.power = power;
		this.type = type;
	}

    public function getName() {
        return name;
    }

	public static final Punch:Move = new Move("Punch", 30, PHYSICAL);
	public static final Blast:Move = new Move("Blast", 20, MAGICAL);
}
