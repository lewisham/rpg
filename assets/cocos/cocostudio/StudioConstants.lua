if nil == ccs then
    return
end

ccs.MovementEventType = {
    start = 0,
    complete = 1,
    loopComplete = 2,
}

ccs.InnerActionType = {
    LoopAction = 0,
    NoLoopAction = 1,
    SingleFrame = 2,
}

ccs.FrameType = {
	VisibleFrame = 1,
	TextureFrame = 2,
	RotationFrame = 3,
	SkewFrame = 4,
	RotationSkewFrame = 5,
	PositionFrame = 6,
	ScaleFrame = 7,
	AnchorPointFrame = 8,
	InnerActionFrame = 9,
	ColorFrame = 10,
	AlphaFrame = 11,
	EventFrame = 12,
	ZOrderFrame = 13,
}