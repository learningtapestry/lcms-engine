function MediaTime(props) {
  const duration = props.duration || 0;
  const minutes = Math.floor(duration/60),
        seconds = duration%60;
  return <span>{`${_.padLeft(minutes, 2, '0')}:${_.padLeft(seconds, 2, '0')}`}</span>
}
