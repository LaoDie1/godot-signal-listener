## 优先级信号监听器
extends Node2D


signal attack(data: Dictionary)


# attack priority 攻击顺序优先级
enum {
	READY = -2,
	BEFORE = -1,
	EXECUTE = 0,
	AFTER = 1,
	FINISH = 2,
}


@onready var listener = $Listener as Listener


func _ready():
	
	listener.listen(self.attack, func(data: Dictionary):
		prints("ready attack:", data)
		data['ready'] = true
	, READY)
	
	listener.listen(self.attack, func(data: Dictionary):
		prints("attacking:", data)
		data['default'] = true
	, EXECUTE)
	
	listener.listen(self.attack, func(data: Dictionary):
		prints("attacked:", data)
		data['after'] = true
	, AFTER)
	
	listener.listen(self.attack, func(data: Dictionary):
		prints("finished:", data)
	, FINISH)
	
	
	# 是否是可攻击的属性
	var enabled_attack = [true]
	
	
	# 打断执行攻击
	listener.listen(self.attack, func(data: Dictionary):
		if not enabled_attack[0]:
			print("interrupt attack")
			listener.prevent_signal(self.attack)
			
			print("====================================")
			# 打断后再次调用
			enabled_attack[0] = true
			self.attack.emit({})
			
	, BEFORE)
	
	
	
	enabled_attack[0] = true
	self.attack.emit({"source": self})
	
	print("=".repeat(50))
	
	enabled_attack[0] = false
	self.attack.emit({"source": self})
	

