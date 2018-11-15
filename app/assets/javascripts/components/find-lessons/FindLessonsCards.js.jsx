function FindLessonsCards(props) {
  return (
    <div className="o-page__wrap--row-nest">
      {props.lessons.map(lesson => {
        const key = `${lesson.id}`;
        return (<LessonCard key={key} lesson={lesson} with_breadcrumb={true}
                            colorCode={colorCodeCss(lesson.subject, lesson.grade)} />);
      })}
    </div>
  );
}
