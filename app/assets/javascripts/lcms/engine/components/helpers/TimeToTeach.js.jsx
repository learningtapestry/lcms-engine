function TimeToTeach(props) {
  const threshold = 600; // 10h = 600min
  const duration = props.duration || 0;
  var value = '';

  if (duration == 0 ) {
    value = '0 minutes'

  } else {
    // if time <=10h (600 min), then output="X hours, Y minutes".
    const quotient = Math.floor(duration / 60);
    const remainder = duration % 60;

    const hours = `${quotient} ${quotient > 1 ? 'hours' : 'hour'}`
    const mins = `${remainder} ${remainder > 1 ? 'minutes' : 'minute'}`

    value = hours + (remainder > 0 ? `, ${remainder}` : '');

    // if time > 10h (600 min), then output ="N Instructional days (X hours, Y minutes)".
    if (duration > threshold) {
      // 1 Instructional day = 60 minutes
      // Always round up to next instructional day (61 min = 2 days)
      const instructionalDays = Math.ceil(duration / 60);
      value = `${instructionalDays} Instructional days (${value})`;
    }
  }

  return <span>{value}</span>
}
