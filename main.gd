## 优先级信号监听器
extends Node2D


signal attack(data: Dictionary)


# 攻击顺序优先级
enum {
	READY,
	BEFORE,
	EXECUTE,
	AFTER,
	FINISH,
}


@onready var listener = $Listener as Listener


func _ready():
	
	# 默认执行功能动作
	listener.listen(self.attack, func(data: Dictionary):
		print("发出攻击，攻击数据：", data)
		data['default'] = true
	, EXECUTE)
	
	# 这个优先级的值只要是小于0的整数，即可比默认连接的执行顺序要靠前
	listener.listen(self.attack, func(data: Dictionary):
		print("准备执行攻击")
		data['before'] = true
	, READY) # -1 优先级
	
	listener.listen(self.attack, func(data: Dictionary):
		print("攻击完成")
		data['after'] = true
	, AFTER)
	
	listener.listen(self.attack, func(data: Dictionary):
		print(data)
	, FINISH)
	
	
	# 是否是可攻击的属性
	var enabled_attack = [true]
	
	
	# 打断执行攻击
	listener.listen(self.attack, func(data: Dictionary):
		if not enabled_attack[0]:
			print("打断执行攻击")
			listener.prevent_signal(self.attack)
	, BEFORE)
	
	
	
	enabled_attack[0] = true
	self.attack.emit({"source": self})
	
	print("=".repeat(50))
	
	enabled_attack[0] = false
	self.attack.emit({"source": self})
	

