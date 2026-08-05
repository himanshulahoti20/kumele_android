import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/shared/components/icons.dart';

final List<BlogCategory> demoBlogCategories = [
  const BlogCategory(label: 'All', isSelected: true),
  const BlogCategory(label: 'Van Life'),
  const BlogCategory(label: 'Psychedelic'),
  const BlogCategory(label: 'Travel'),
  const BlogCategory(label: 'Food'),
];

final List<BlogType> demoBlogs = [
  BlogType(
    image: IconSet.blogDefaultImage,
    title: 'Singleton of Glen Ord 38-Year-Old and the Singleton Range.',
    type: 'Van Life',
    host: 'Adventure Explorer',
    date: '23 August, 2023',
    maincontent:
        'Embark on a journey through scenic landscapes and memorable destinations with Adventure Explorer.',
    blogPost: [
      BlogPost(
        videoUrl: '',
        image: testImage6,
        content:
            'The Van Life adventure begins as we hit the open road and discover hidden gems along the way.',
      ),
      BlogPost(
        videoUrl: '',
        image: testImage7,
        content:
            'We dive into the details behind the Singleton of Glen Ord 38-year-old whiskey and the broader range.',
      ),
    ],
    comments: [
      Comment(
        name: 'Josh Durrant',
        profile: blogImage1,
        comment:
            'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint.',
        date: '23 August, 2023',
        time: '10:30 AM',
        expanded: false,
        replays: [
          Replay(
            name: 'Alkesh Sharma',
            tag: ['Josh Durrant'],
            profile: testImage2,
            comment: 'What a display.',
            date: '23 August, 2023',
            time: '11:00 AM',
          ),
        ],
      ),
      Comment(
        name: 'Jakob Hoffman',
        profile: blogImage2,
        comment:
            'I am inspired to plan my own van life adventure. Any tips for the journey?',
        date: '23 August, 2023',
        time: '11:15 AM',
        expanded: false,
        replays: [],
      ),
    ],
  ),
  BlogType(
    image: IconSet.blogDefaultImage,
    title: 'Exploring Psychedelic Realms',
    type: 'Psychedelic',
    host: 'Mindful Journeys',
    date: '25 August, 2023',
    maincontent:
        'A mesmerizing journey into psychedelic realms of the mind and the perspectives that come with it.',
    blogPost: [
      BlogPost(
        videoUrl: '',
        image: testImage6,
        content:
            'Dive deep into the vibrant tapestry of psychedelic exploration and self-discovery.',
      ),
      BlogPost(
        videoUrl: '',
        image: testImage7,
        content:
            'Explore the intersections of art, science, and spirituality in the psychedelic landscape.',
      ),
    ],
    comments: [
      Comment(
        name: 'Alice Turner',
        profile: testImage2,
        comment: 'This sounds fascinating. Can’t wait to read more.',
        date: '25 August, 2023',
        time: '10:30 AM',
        expanded: false,
        replays: [
          Replay(
            name: 'Mindful Explorer',
            tag: ['Alice Turner'],
            profile: testImage3,
            comment: 'Thank you, Alice. We are thrilled to have you here.',
            date: '25 August, 2023',
            time: '11:00 AM',
          ),
        ],
      ),
    ],
  ),
  BlogType(
    image: IconSet.blogDefaultImage,
    title: 'City Nights and Hidden Stories',
    type: 'Travel',
    host: 'Urban Explorer',
    date: '29 August, 2023',
    maincontent:
        'A reflective look at the energy of city nights, hidden corners, and the stories inside them.',
    blogPost: [
      BlogPost(
        videoUrl: '',
        image: testImage6,
        content:
            'We walk through the city after dark, finding texture, light, and small moments everywhere.',
      ),
      BlogPost(
        videoUrl: '',
        image: testImage7,
        content:
            'Each block has a story, and every turn opens up something new to notice and enjoy.',
      ),
    ],
    comments: [
      Comment(
        name: 'Mia Carter',
        profile: blogImage3,
        comment: 'Love this visual direction. It feels really alive.',
        date: '29 August, 2023',
        time: '09:15 AM',
        expanded: false,
        replays: [],
      ),
    ],
  ),
  BlogType(
    image: IconSet.blogDefaultImage,
    title: 'Weekend Food Finds Worth Sharing',
    type: 'Food',
    host: 'Taste Notes',
    date: '01 September, 2023',
    maincontent:
        'A compact roundup of the most satisfying food discoveries from a weekend of exploring.',
    blogPost: [
      BlogPost(
        videoUrl: '',
        image: testImage6,
        content:
            'From the first bite to the last, this round of food finds was all about comfort and surprise.',
      ),
      BlogPost(
        videoUrl: '',
        image: testImage7,
        content:
            'A simple plate, a strong flavor, and the right company can turn a small moment into a memory.',
      ),
    ],
    comments: [
      Comment(
        name: 'Noah Reed',
        profile: blogImage1,
        comment: 'Adding this place to my list immediately.',
        date: '01 September, 2023',
        time: '12:40 PM',
        expanded: false,
        replays: [],
      ),
    ],
  ),
];
